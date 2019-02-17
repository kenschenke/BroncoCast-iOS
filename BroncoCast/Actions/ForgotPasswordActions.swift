//
//  ForgotPasswordActions.swift
//  BroncoCast
//
//  Created by Ken Schenke on 2/16/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift
import Alamofire
import SwiftyJSON

struct ForgotPasswordInit : Action {
    
}

struct SetForgotPasswordEmail : Action {
    var email : String
}

struct SetForgotPasswordPhone : Action {
    var phone : String
}

struct SetForgotPasswordFinding : Action {
    var finding : Bool
}

struct SetForgotPasswordFindingErrorMsg : Action {
    var findingErrorMsg : String
}

struct SetForgotPasswordRecovering : Action {
    var recovering : Bool
}

struct SetForgotPasswordRecoveringErrorMsg : Action {
    var recoveringErrorMsg : String
}

struct SetForgotPasswordFound : Action {
    var found : Bool
}

struct SetForgotPasswordNewPassword : Action {
    var password : String
}

struct SetForgotPasswordCode : Action {
    var code : String
}

struct SetForgotPasswordRecovered : Action {
    var recovered : Bool
}

func resetPassword(state : AppState, store : Store<AppState>) -> Action? {
    store.dispatch(SetForgotPasswordRecovering(recovering: true))
    store.dispatch(SetForgotPasswordRecoveringErrorMsg(recoveringErrorMsg: ""))
    
    let email = state.forgotPasswordState.email
    let phone = state.forgotPasswordState.phone
    
    let params : [String : String] = [
        "Contact" : email.isEmpty ? phone : email,
        "Code" : state.forgotPasswordState.code,
        "Password" : state.forgotPasswordState.password
        ]
    Alamofire.request(UrlMaker.makeUrl(.recover_save), method: .post, parameters: params).responseJSON {
        response in
        store.dispatch(SetForgotPasswordRecovering(recovering: false))
        if response.result.isSuccess {
            let responseJSON : JSON = JSON(response.result.value!)
            
            if responseJSON["Success"].bool ?? false {
                store.dispatch(SetForgotPasswordRecovered(recovered: true))
            } else {
                store.dispatch(SetForgotPasswordRecoveringErrorMsg(recoveringErrorMsg: responseJSON["Error"].string ?? ""))
            }
        } else {
            store.dispatch(SetForgotPasswordRecoveringErrorMsg(recoveringErrorMsg: "Unable to recover account"))
        }
    }
 
    return nil
}

func findAccount(state : AppState, store : Store<AppState>) -> Action? {
    store.dispatch(SetForgotPasswordFinding(finding: true))
    store.dispatch(SetForgotPasswordFindingErrorMsg(findingErrorMsg: ""))
    
    let email = state.forgotPasswordState.email
    let phone = state.forgotPasswordState.phone
    
    let params : [String : String] = [
        "Contact" : email.isEmpty ? phone : email,
        ]
    Alamofire.request(UrlMaker.makeUrl(.recover_send), method: .post, parameters: params).responseJSON {
        response in
        store.dispatch(SetForgotPasswordFinding(finding: false))
        if response.result.isSuccess {
            let responseJSON : JSON = JSON(response.result.value!)
            
            if responseJSON["Success"].bool ?? false {
                store.dispatch(SetForgotPasswordFound(found: true))
            } else {
                store.dispatch(SetForgotPasswordFindingErrorMsg(findingErrorMsg: responseJSON["Error"].string ?? ""))
            }
        } else {
            store.dispatch(SetForgotPasswordFindingErrorMsg(findingErrorMsg: "Unable to recover account"))
        }
    }
    
    return nil
}
