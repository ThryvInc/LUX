//
//  PlaygroundVCHelpers.swift
//  PlaygroundVCHelpers
//
//  Created by Elliot Schrock on 8/2/19.
//

import UIKit

public func loadViewFromNib<T>(owner: T, nibName: String = String(describing: T.self), bundle: Bundle? = Bundle(for: T.self)) -> UIView? where T: UIViewController {
    let nib = UINib(nibName: nibName, bundle: bundle)
    let view = nib.instantiate(withOwner: owner, options: nil).first as? UIView
    return view
}

public func loadVCFromStoryboard<T>(named: String, isInitialVC: Bool = false, storyboardId: String? = nil, bundle: Bundle = Bundle(for: T.self)) -> T? where T: UIViewController {
    let storyboard = UIStoryboard(name: named, bundle: bundle)
    if isInitialVC {
        return storyboard.instantiateInitialViewController() as? T
    } else if let id = storyboardId {
        return storyboard.instantiateViewController(withIdentifier: id) as? T
    }
    return nil
}

public protocol StoryboardInitializable: class { }

public extension StoryboardInitializable {
    static func makeFromStoryboard(name: String? = nil, identifier: String? = nil) -> Self {
        let storyboardName = name ?? String(describing: self)
        let storyboardIdentifier = identifier ?? String(describing: self)
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle(for: self))
        let optionalViewController = storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as? Self
        guard let viewController = optionalViewController else { fatalError() }
        return viewController
    }
}

public protocol XIBInitializable: class {
    init(nibName: String?, bundle: Bundle?)
}

public extension XIBInitializable {
    static func makeFromXIB(name: String? = nil, bundle: Bundle? = nil) -> Self {
        let nibName = name ?? String(describing: self)
        let bundle = bundle ?? Bundle(for: self)
        return self.init(nibName: nibName, bundle: bundle)
    }
}

extension UIViewController: XIBInitializable {}
extension UIViewController: StoryboardInitializable {}
