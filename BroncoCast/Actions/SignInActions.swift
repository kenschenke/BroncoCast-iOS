//
//  SignInActions.swift
//  BroncoCast
//
//  Created by Ken Schenke on 12/30/18.
//  Copyright © 2018 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift
import Alamofire
import SwiftyJSON

struct SetSigningIn : Action {
    let signingIn : Bool
}

struct SetSigningInErrorMsg : Action {
    let errorMsg : String
}

struct SetSigningInUsername : Action {
    let username : String
}

struct SetSigningInPassword : Action {
    let password : String
}

struct SetDeviceToken : Action {
    var deviceToken : String
}

struct SetLaunchedBroadcastId : Action {
    var broadcastId : Int
}

func isAuth(state : AppState, store : Store<AppState>) -> Action? {
    var url = UrlMaker.makeUrl(.is_auth)
    if !state.signInState.deviceToken.isEmpty {
        url += "?DeviceToken=\(state.signInState.deviceToken)&DeviceType=APPLE"
    }
    Alamofire.request(url, method: .get).responseJSON {
        response in
        if response.result.isSuccess {
            let responseJSON : JSON = JSON(response.result.value!)
            if responseJSON["IsAuth"].bool ?? false {
                store.dispatch(navigateTo(path:
                    state.signInState.launchedBroadcastId != 0 ? .mybroadcasts : .profile_name))
                setAdminOrgData(store: store, responseJSON: responseJSON)
                return
            }
        }
        
        store.dispatch(navigateTo(path: .auth_signin))
    }

    return nil
}

func logout(state : AppState, store : Store<AppState>) -> Action? {
    Alamofire.request(UrlMaker.makeUrl(.logout), method: .get).responseJSON {
        response in
        if response.result.isSuccess {
            let responseJSON : JSON = JSON(response.result.value!)
            if responseJSON["Success"].bool ?? false {
                store.dispatch(navigateTo(path: .auth_signin))
            }
        }
    }
    
    return nil
}

func signIn(state : AppState, store : Store<AppState>) -> Action? {
    store.dispatch(SetSigningInErrorMsg(errorMsg: ""))

    if state.signInState.username.isEmpty {
        return SetSigningInErrorMsg(errorMsg: "Email or phone number required")
    }
    if state.signInState.password.isEmpty {
        return SetSigningInErrorMsg(errorMsg: "Password required")
    }
    
    store.dispatch(SetSigningIn(signingIn: true))
    
    var params : [String : String] = [
        "_username" : state.signInState.username,
        "_password" : state.signInState.password,
        "_remember_me" : "on",
        "applogin": "true"
    ]
    if !state.signInState.deviceToken.isEmpty {
        params["DeviceToken"] = state.signInState.deviceToken
        params["DeviceType"] = "FCM_APPLE"
    }
    Alamofire.request(UrlMaker.makeUrl(.sign_in), method: .post, parameters: params).responseJSON {
        response in
        if response.result.isSuccess {
            let responseJSON : JSON = JSON(response.result.value!)
            if responseJSON["Success"].bool! {
                store.dispatch(navigateTo(path: .profile_name))
                setAdminOrgData(store: store, responseJSON: responseJSON)
            } else {
                store.dispatch(SetSigningInErrorMsg(errorMsg: responseJSON["Error"].string!))
            }
        } else {
            store.dispatch(SetSigningInErrorMsg(errorMsg: "Unable to sign in"))
        }
        
        store.dispatch(SetSigningIn(signingIn: false))
    }
    
    return nil
}

func setAdminOrgData(store : Store<AppState>, responseJSON : JSON) {
    if responseJSON["AdminOrgs"].array != nil {
        var adminOrgs : [AdminOrg] = []

        for (_, object) in responseJSON["AdminOrgs"] {
            let AdminDefault = object["AdminDefault"].bool ?? false
            let OrgId = object["OrgId"].int ?? 0
            let OrgName = object["OrgName"].string ?? ""
            
            adminOrgs.append(AdminOrg(
                AdminDefault: AdminDefault,
                OrgId: OrgId,
                DefaultTZ: object["DefaultTZ"].string ?? "",
                OrgName: OrgName
            ))
            
            if AdminDefault {
                store.dispatch(SetAdminOrg(
                    adminOrgId: OrgId,
                    adminOrgName: OrgName)
                )
            }
        }
        
        store.dispatch(SetAdminOrgs(adminOrgs: adminOrgs, notAdmin: adminOrgs.isEmpty))
    }
}
