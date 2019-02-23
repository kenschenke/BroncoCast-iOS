//
//  AppSettings.swift
//  BroncoCast
//
//  Created by Ken Schenke on 2/12/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import Foundation

class AppSettings {
    let defaults = UserDefaults.standard
    var serverAddr = ""
    
    func load() {
        if let serverSetting = defaults.string(forKey: "Server") {
            serverAddr = serverSetting
        } else {
            serverAddr = "www.broncocast.org"
        }
    }
    
    func save(newServer : String) {
        defaults.set(newServer, forKey: "Server")
        serverAddr = newServer
    }
}
