//
//  PlaygroundVCHelpers.swift
//  PlaygroundVCHelpers
//
//  Created by Elliot Schrock on 8/2/19.
//

import Foundation

public func loadViewFromNib<T>(owner: T, nibName: String = String(describing: T.self), bundle: Bundle = Bundle(for: T.self)) -> UIView? where T: UIViewController {
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
