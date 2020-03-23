//
//  SplashViewModel.swift
//  ThryvUXComponents
//
//  Created by Elliot Schrock on 2/11/18.
//

import UIKit
import Combine
import Prelude

public protocol LUXSplashTask {
    func execute(completion: @escaping () -> Void)
}

public protocol LUXSplashInputs {
    func viewDidLoad()
    func viewWillAppear()
    func viewDidAppear()
}

public protocol LUXSplashOutputs {
    var performAnimationsPublisher: AnyPublisher<(), Never> { get }
    var advanceUnauthedPublisher: AnyPublisher<(), Never> { get }
    var advanceAuthedPublisher: AnyPublisher<(), Never> { get }
    var displayableViewControllerPublisher: AnyPublisher<UIViewController, Never> { get }
}

public protocol LUXSplashProtocol {
    var inputs: LUXSplashInputs { get }
    var outputs: LUXSplashOutputs { get }
}

open class LUXSplashViewModel: LUXSplashInputs, LUXSplashOutputs, LUXSplashProtocol {
    public var inputs: LUXSplashInputs { return self }
    public var outputs: LUXSplashOutputs { return self }
    
    public let performAnimationsPublisher: AnyPublisher<(), Never>
    public let performAnimations = PassthroughSubject<(), Never>()
    
    public let advanceAuthedPublisher: AnyPublisher<(), Never>
    public let advanceAuthed = PassthroughSubject<(), Never>()

    public let advanceUnauthedPublisher: AnyPublisher<(), Never>
    public let advanceUnauthed = PassthroughSubject<(), Never>()
    
    public let displayableViewControllerPublisher: AnyPublisher<UIViewController, Never>
    public let displayableViewController = PassthroughSubject<UIViewController?, Never>()
    
    public let viewDidLoadSubject = PassthroughSubject<(), Never>()
    public let viewWillAppearSubject = PassthroughSubject<(), Never>()
    public let viewDidAppearSubject = PassthroughSubject<(), Never>()
    
    @Published public var isAuthed = false
    
    @Published public var semaphore = 0
    
    private var cancelBag = Set<AnyCancellable?>()
    
    public init(minimumVisibleTime: Double?, _ versionChecker: LUXVersionChecker? = nil, _ session: LUXSession? = LUXSessionManager.primarySession, otherTasks: [LUXSplashTask]?) {
        performAnimationsPublisher = performAnimations.eraseToAnyPublisher()
        advanceAuthedPublisher = advanceAuthed.eraseToAnyPublisher()
        advanceUnauthedPublisher = advanceUnauthed.eraseToAnyPublisher()
        displayableViewControllerPublisher = displayableViewController.compactMap({ $0 }).eraseToAnyPublisher()
        
        var semaphore = 0
        
        semaphore += 1                                  // view must appear
        semaphore += otherTasks?.count ?? 0             // other tasks to be executed
        semaphore += versionChecker == nil ? 0 : 1      // check version
        semaphore += session == nil ? 0 : 1             // check session
        
        cancelBag.insert(viewDidLoadSubject.eraseToAnyPublisher().sink { _ in
            versionChecker?.isCurrentVersion(appVersion: versionChecker?.appVersionString() ?? "0.0.0", completion: { isCurrent in
                if isCurrent {
                    self.semaphore -= 1
                } else {
                    self.displayableViewController.send(self.versionUpdatePrompt())
                }
            })
            
            if let tasks = otherTasks {
                for task in tasks {
                    task.execute {
                        self.semaphore -= 1
                    }
                }
            }
            
            if let isAuthed = session?.isAuthenticated() {
                self.isAuthed = isAuthed
            }
        })
        
        cancelBag.insert(viewDidAppearSubject.eraseToAnyPublisher().sink{ _ in
            self.semaphore -= 1
            
            self.performAnimations.send(())
        })
        
        if let minTime = minimumVisibleTime {
            semaphore += 1
            cancelBag.insert(viewWillAppearSubject.eraseToAnyPublisher().sink { _ in
                DispatchQueue.main.asyncAfter(deadline: (.now() + minTime)) {
                    self.semaphore -= 1
                }
            })
        }
        
        cancelBag.insert($isAuthed.eraseToAnyPublisher().sink { (isAuthed) in
            self.semaphore -= 1
        })
        
        self.semaphore = semaphore
        
        cancelBag.insert($semaphore.sink { value in
            if value == 0 {
                if self.isAuthed {
                    self.advanceAuthed.send(())
                } else {
                    self.advanceUnauthed.send(())
                }
            }
        })
    }
    
    open func versionUpdatePrompt() -> UIViewController {
        //override me!
        return UIViewController()
    }
    
    // MARK: - Inputs
    
    open func viewDidLoad() {
        viewDidLoadSubject.send(())
    }
    
    open func viewWillAppear() {
        viewWillAppearSubject.send(())
    }
    
    open func viewDidAppear() {
        viewDidAppearSubject.send(())
    }
}
