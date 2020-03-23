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
