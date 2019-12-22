//
//  ServerAuth.swift
//  FunNet
//
//  Created by Elliot Schrock on 8/22/19.
//

import FunNet
import THUXAuth

public func authorize(_ endpoint: inout Endpoint) {
    if let headers = THUXSessionManager.primarySession?.authHeaders() {
        endpoint.addHeaders(headers: headers)
    }
}
