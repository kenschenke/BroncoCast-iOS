//
//  RegistrationActions.swift
//  BroncoCast
//
//  Created by Ken Schenke on 2/16/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift
import Alamofire
import SwiftyJSON

struct RegistrationInit : Action {
    
}

struct SetRegistrationName : Action {
    var name : String
}

struct SetRegistrationEmail : Action {
    var email : String
}

struct SetRegistrationPassword : Action {
    var password : String
}

struct SetRegistrationPhone : Action {
    var phone : String
}

struct SetRegistrationRegistering : Action {
    var registering : Bool
}

struct SetRegistrationErrorMsg : Action {
    var errorMsg : String
}

struct SetRegistrationOrgTag : Action {
    var orgTag : String
}

func registerUser(state : AppState, store : Store<AppState>) -> Action? {
    store.dispatch(SetRegistrationRegistering(registering: true))
    store.dispatch(SetRegistrationErrorMsg(errorMsg: ""))
    
    let params : [String : String] = [
        "Name" : state.registrationState.name,
        "Password" : state.registrationState.password,
        "Email" : state.registrationState.email,
        "Phone" : state.registrationState.phone,
        "OrgTag" : state.registrationState.orgTag,
        ]
    Alamofire.request(UrlMaker.makeUrl(.register), method: .post, parameters: params).responseJSON {
        response in
        store.dispatch(SetRegistrationRegistering(registering: false))
        if response.result.isSuccess {
            let responseJSON : JSON = JSON(response.result.value!)
            
            if responseJSON["Success"].bool ?? false {
                // "Fill In" the sign in form then dispatch the sign in action
                store.dispatch(SetSigningInUsername(username: state.registrationState.email))
                store.dispatch(SetSigningInPassword(password: state.registrationState.password))
                store.dispatch(signIn)
            } else {
                store.dispatch(SetRegistrationErrorMsg(errorMsg: responseJSON["Error"].string ?? ""))
            }
        } else {
            store.dispatch(SetRegistrationErrorMsg(errorMsg: "Unable to register at this time"))
        }
    }
    
    return nil
}
