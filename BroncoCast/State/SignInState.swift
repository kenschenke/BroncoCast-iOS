//
//  SignInState.swift
//  BroncoCast
//
//  Created by Ken Schenke on 12/30/18.
//  Copyright © 2018 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift

struct SignInState : StateType {
    var username = ""
    var password = ""
    var signingIn = false
    var errorMsg = ""
    var deviceToken = ""  // for push notifications
    
    // If the app was launched by the user tapping a notification,
    // this will contain the id of the broadcast for the notification.
    var launchedBroadcastId = 0
}
