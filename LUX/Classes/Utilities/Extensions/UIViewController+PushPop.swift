//
//  UIViewController+PushPop.swift
//  LUX
//
//  Created by Elliot Schrock on 12/23/19.
//

import UIKit

public extension UIViewController {
    func pushAnimated(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func popAnimated() {
        navigationController?.popViewController(animated: true)
    }
    
    func presentAnimated(_ vc: UIViewController) {
        present(vc, animated: true, completion: nil)
    }
    
    func tabContainer() -> UITabBarController? {
        return tabBarController
    }
    
    func tabPushAnimated(_ vc: UIViewController) {
        tabBarController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tabPopAnimated() {
        tabBarController?.navigationController?.popViewController(animated: true)
    }
    
    func tabPresentAnimated(_ vc: UIViewController) {
        tabBarController?.present(vc, animated: true, completion: nil)
    }
}

public func pushAnimated<T>(_ pusher: T, _ pushee: UIViewController) where T: UIViewController {
    pusher.pushAnimated(pushee)
}

public func popAnimated<T>(_ vc: T) where T: UIViewController {
    vc.popAnimated()
}

public func presentAnimated<T>(_ presenter: T, _ vc: UIViewController) where T: UIViewController {
    presenter.present(vc, animated: true, completion: nil)
}

public func tabPushAnimated<T>(_ pusher: T, _ vc: UIViewController) where T: UIViewController {
    pusher.tabBarController?.navigationController?.pushViewController(vc, animated: true)
}

public func tabPopAnimated<T>(_ vc: T) where T: UIViewController {
    vc.tabBarController?.navigationController?.popViewController(animated: true)
}

public func tabPresentAnimated<T>(_ presenter: T, _ vc: UIViewController) where T: UIViewController {
    presenter.tabBarController?.present(vc, animated: true, completion: nil)
}
