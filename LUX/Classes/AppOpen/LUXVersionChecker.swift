//
//  LUXVersionChecker.swift
//  ThryvUXComponents
//
//  Created by Elliot Schrock on 2/10/18.
//

import UIKit

public protocol LUXVersionChecker {
    func isCurrentVersion(appVersion: String, completion: (Bool) -> Void)
    func appVersionString() -> String
}
