//
//  ForgotPasswordReducer.swift
//  BroncoCast
//
//  Created by Ken Schenke on 2/16/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift

func forgotPasswordReducer(_ action : Action, state: ForgotPasswordState?) -> ForgotPasswordState {
    var newState = state ?? ForgotPasswordState()
    
    if let _ = action as? ForgotPasswordInit {
        newState.phone = ""
        newState.email = ""
        newState.finding = false
        newState.findingErrorMsg = ""
        newState.recovering = false
        newState.recoveringErrorMsg = ""
        newState.found = false
        newState.password = ""
        newState.code = ""
        newState.recovered = false
    }
    else if let setForgotPasswordEmail = action as? SetForgotPasswordEmail {
        newState.email = setForgotPasswordEmail.email
    }
    else if let setForgotPasswordPhone = action as? SetForgotPasswordPhone {
        newState.phone = setForgotPasswordPhone.phone
    }
    else if let setForgotPasswordFinding = action as? SetForgotPasswordFinding {
        newState.finding = setForgotPasswordFinding.finding
    }
    else if let setForgotPasswordFindingErrorMsg = action as? SetForgotPasswordFindingErrorMsg {
        newState.findingErrorMsg = setForgotPasswordFindingErrorMsg.findingErrorMsg
    }
    else if let setForgotPasswordRecovering = action as? SetForgotPasswordRecovering {
        newState.recovering = setForgotPasswordRecovering.recovering
    }
    else if let setForgotPasswordRecoveringErrorMsg = action as? SetForgotPasswordRecoveringErrorMsg {
        newState.recoveringErrorMsg = setForgotPasswordRecoveringErrorMsg.recoveringErrorMsg
    }
    else if let setForgotPasswordFound = action as? SetForgotPasswordFound {
        newState.found = setForgotPasswordFound.found
    } else if let setForgotPasswordNewPassword = action as? SetForgotPasswordNewPassword {
        newState.password = setForgotPasswordNewPassword.password
    } else if let setForgotPasswordCode = action as? SetForgotPasswordCode {
        newState.code = setForgotPasswordCode.code
    } else if let setForgotPasswordRecovered = action as? SetForgotPasswordRecovered {
        newState.recovered = setForgotPasswordRecovered.recovered
    }

    return newState
}

