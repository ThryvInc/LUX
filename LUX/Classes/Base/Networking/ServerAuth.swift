//
//  ServerAuth.swift
//  FunNet
//
//  Created by Elliot Schrock on 8/22/19.
//

import FunNet

public func authorize(_ endpoint: inout Endpoint) {
    if let headers = LUXSessionManager.primarySession?.authHeaders() {
        endpoint.addHeaders(headers: headers)
    }
}
