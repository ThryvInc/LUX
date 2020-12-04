//
//  iOSFunctions.swift
//  LUX
//
//  Created by Elliot Schrock on 12/4/20.
//

import Foundation

public func ifSimulator(f: @escaping () -> Void) -> () -> Void {
    #if targetEnvironment(simulator)
    return f
    #else
    return {}
    #endif
}

public func ifSimulator<T>(f: @escaping (T) -> Void) -> (T) -> Void {
    #if targetEnvironment(simulator)
    return f
    #else
    return { _ in }
    #endif
}

public func ifDevice(f: @escaping () -> Void) -> () -> Void {
    #if targetEnvironment(simulator)
    return {}
    #else
    return f
    #endif
}

public func ifDevice<T>(f: @escaping (T) -> Void) -> (T) -> Void {
    #if targetEnvironment(simulator)
    return { _ in }
    #else
    return f
    #endif
}
