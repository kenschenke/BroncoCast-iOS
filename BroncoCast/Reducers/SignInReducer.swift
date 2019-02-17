//
//  SignInReducer.swift
//  BroncoCast
//
//  Created by Ken Schenke on 12/30/18.
//  Copyright © 2018 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift

func signInReducer(_ action : Action, state: SignInState?) -> SignInState {
    var newState = state ?? SignInState()
    
    if let signingInAction = action as? SetSigningIn {
        newState.signingIn = signingInAction.signingIn
    } else if let signingInErrorAction = action as? SetSigningInErrorMsg {
        newState.errorMsg = signingInErrorAction.errorMsg
    } else if let signingInUsername = action as? SetSigningInUsername {
        newState.username = signingInUsername.username
    } else if let signingInPassword = action as? SetSigningInPassword {
        newState.password = signingInPassword.password
    } else if let setDeviceToken = action as? SetDeviceToken {
        newState.deviceToken = setDeviceToken.deviceToken
    } else if let setLaunchedBroadcastId = action as? SetLaunchedBroadcastId {
        newState.launchedBroadcastId = setLaunchedBroadcastId.broadcastId
    }

    
    return newState
}
