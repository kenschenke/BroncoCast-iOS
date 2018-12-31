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

func isAuth(state : AppState, store : Store<AppState>) -> Action? {
    Alamofire.request(UrlMaker.makeUrl(.is_auth), method: .get).responseJSON {
        response in
        if response.result.isSuccess {
            let responseJSON : JSON = JSON(response.result.value!)
            if responseJSON["IsAuth"].bool ?? false {
                store.dispatch(NavigateToMainAction())
                setAdminOrgData(store: store, responseJSON: responseJSON)
                return
            }
        }
        
        store.dispatch(NavigateToSignInAction())
    }

    return nil
}

func logout(state : AppState, store : Store<AppState>) -> Action? {
    Alamofire.request(UrlMaker.makeUrl(.logout), method: .get).responseJSON {
        response in
        if response.result.isSuccess {
            let responseJSON : JSON = JSON(response.result.value!)
            if responseJSON["Success"].bool ?? false {
                store.dispatch(NavigateToSignInAction())
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
    
    let params : [String : String] = [
        "_username" : state.signInState.username,
        "_password" : state.signInState.password,
        "_remember_me" : "on",
        "applogin": "true",
    ]
    Alamofire.request(UrlMaker.makeUrl(.sign_in), method: .post, parameters: params).responseJSON {
        response in
        if response.result.isSuccess {
            let responseJSON : JSON = JSON(response.result.value!)
            if responseJSON["Success"].bool! {
                store.dispatch(NavigateToMainAction())
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
            adminOrgs.append(AdminOrg(
                AdminDefault: object["AdminDefault"].bool ?? false,
                OrgId: object["OrgId"].int ?? 0,
                DefaultTZ: object["DefaultTZ"].string ?? "",
                OrgName: object["OrgName"].string ?? ""
            ))
        }
        
        store.dispatch(SetAdminOrgs(adminOrgs: adminOrgs, notAdmin: adminOrgs.isEmpty))
    }
}
