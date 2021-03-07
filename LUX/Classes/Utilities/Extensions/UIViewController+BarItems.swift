//
//  UIViewController+BarItems.swift
//  LUX
//
//  Created by Elliot Schrock on 3/7/21.
//

import Foundation

extension UIViewController {
    func barButtonItem(for imageName: String, selector: Selector) -> UIBarButtonItem {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        
        let barButton = UIBarButtonItem()
        barButton.customView = button
        return barButton
    }
}
