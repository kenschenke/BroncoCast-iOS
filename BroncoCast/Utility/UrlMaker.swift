//
//  UrlMaker.swift
//  BroncoCast
//
//  Created by Ken Schenke on 12/30/18.
//  Copyright © 2018 Ken Schenke. All rights reserved.
//

import Foundation

struct UrlMaker {
    enum UrlConstant : String {
        case is_auth = "auth/isauth"
        case sign_in = "auth/login"
        case logout = "logout?applogout"
        
        case profile = "api/profile"
        
        case user_broadcasts = "api/broadcasts"
    }
    
    static func makeUrl(_ url : UrlConstant) -> String {
        return "http://dev.broncocast.org/\(url.rawValue)"
    }
}
