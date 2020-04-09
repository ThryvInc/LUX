//
//  LUXSessionManager.swift
//  LUX/Auth
//
//  Created by Elliot Schrock on 7/15/19.
//

import Foundation

@objc public protocol LUXSession {
    @objc func authHeaders() -> [String: String]?
    @objc var host: String { get }
    
    @objc func isAuthenticated() -> Bool
}

open class LUXSessionManager: NSObject {
    public static var primarySession: LUXSession?
    public static var allSessions: [LUXSession] = [LUXSession]()
    
    public static func sessionFor(host: String) -> LUXSession? {
        for session in allSessions {
            if session.host == host {
                return session
            }
        }
        return nil
    }
}

open class LUXMultiHeaderDefaultsSession: LUXSession {
    public let host: String
    public let headers: [String: String]
    
    public init(host: String, authHeaders: [String: String]) {
        self.host = host
        self.headers = authHeaders
    }
    
    open func authHeaders() -> [String: String]? {
        return UserDefaults.standard.dictionary(forKey: host) as? [String: String]
    }
    
    open func setAuthHeaders(authString: String) {
        UserDefaults.standard.set(authString, forKey: host)
        UserDefaults.standard.synchronize()
    }
    
    open func isAuthenticated() -> Bool {
        if let headers = UserDefaults.standard.dictionary(forKey: host) as? [String: String] {
            if headers.keys.count == 0 { return false }
            for key in headers.keys {
                if let value = headers[key] {
                    if value.isEmpty { return false }
                } else {
                    return false
                }
            }
            return true
        }
        return false
    }
}

open class LUXUserDefaultsSession: LUXSession {
    public let host: String
    public let authHeaderKey: String
    
    public init(host: String, authHeaderKey: String) {
        self.host = host
        self.authHeaderKey = authHeaderKey
    }
    
    open func authHeaders() -> [String: String]? {
        return [authHeaderKey: UserDefaults.standard.string(forKey: host) ?? ""]
    }
    
    open func setAuthValue(authString: String) {
        UserDefaults.standard.set(authString, forKey: host)
        UserDefaults.standard.synchronize()
    }

    open func clearAuthValue() {
        UserDefaults.standard.removeObject(forKey: host)
    }
    
    open func isAuthenticated() -> Bool {
        let apiKey = UserDefaults.standard.string(forKey: host)
        return apiKey != nil && apiKey != ""
    }
}

