//
//  RegistrationReducer.swift
//  BroncoCast
//
//  Created by Ken Schenke on 2/16/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift

func registrationReducer(_ action : Action, state: RegistrationState?) -> RegistrationState {
    var newState = state ?? RegistrationState()
    
    if let _ = action as? RegistrationInit {
        newState.name = ""
        newState.password = ""
        newState.email = ""
        newState.phone = ""
        newState.registering = false
        newState.errorMsg = ""
    }
    else if let setRegistrationName = action as? SetRegistrationName {
        newState.name = setRegistrationName.name
    } else if let setRegistrationPassword = action as? SetRegistrationPassword {
        newState.password = setRegistrationPassword.password
    } else if let setRegistrationEmail = action as? SetRegistrationEmail {
        newState.email = setRegistrationEmail.email
    } else if let setRegistrationPhone = action as? SetRegistrationPhone {
        newState.phone = setRegistrationPhone.phone
    } else if let setRegistrationRegistering = action as? SetRegistrationRegistering {
        newState.registering = setRegistrationRegistering.registering
    } else if let setRegistrationErrorMsg = action as? SetRegistrationErrorMsg {
        newState.errorMsg = setRegistrationErrorMsg.errorMsg
    }
    
    return newState
}

