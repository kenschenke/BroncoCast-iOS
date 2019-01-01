//
//  ProfileNameActions.swift
//  BroncoCast
//
//  Created by Ken Schenke on 12/31/18.
//  Copyright © 2018 Ken Schenke. All rights reserved.
//

import Foundation
import Alamofire
import ReSwift
import SwiftyJSON

func getProfile(state : AppState, store : Store<AppState>) -> Action? {
    store.dispatch(SetProfileErrorMsg(errorMsg: ""))
    store.dispatch(SetProfileGetting(getting: true))
    
    Alamofire.request(UrlMaker.makeUrl(.profile), method: .get).responseJSON {
        response in
        store.dispatch(SetProfileGetting(getting: false))
        if response.result.isSuccess {
            let responseJSON : JSON = JSON(response.result.value!)

            if responseJSON["Success"].bool ?? false {
                store.dispatch(SetProfileName(name: responseJSON["UsrName"].string ?? ""))
                store.dispatch(SetProfileSingleMsg(singleMsg: responseJSON["SingleMsg"].bool ?? false))
            } else {
                store.dispatch(SetProfileErrorMsg(errorMsg: responseJSON["Error"].string ?? ""))
            }
        } else {
            store.dispatch(SetProfileErrorMsg(errorMsg: "Unable to retrieve profile information"))
        }
    }
    
    return nil
}

func saveProfile(state : AppState, store : Store<AppState>) -> Action? {
    store.dispatch(SetProfileErrorMsg(errorMsg: ""))
    store.dispatch(SetProfileUpdating(updating: true))
    store.dispatch(SetProfileSaved(saved: false))
    
    let params : [String : String] = [
        "UsrName" : state.profileNameState.name,
        "SingleMsg" : String(state.profileNameState.singleMsg),
    ]
    Alamofire.request(UrlMaker.makeUrl(.profile), method: .post, parameters: params).responseJSON {
        response in
        store.dispatch(SetProfileUpdating(updating: false))
        if response.result.isSuccess {
            let responseJSON : JSON = JSON(response.result.value!)

            if responseJSON["Success"].bool ?? false {
                store.dispatch(SetProfileSaved(saved: true))
            } else {
                store.dispatch(SetProfileErrorMsg(errorMsg: responseJSON["Error"].string ?? ""))
            }
        } else {
            store.dispatch(SetProfileErrorMsg(errorMsg: "Unable to save profile information"))
        }
    }
    
    return nil
}

struct SetProfileGetting : Action {
    var getting : Bool
}

struct SetProfileName : Action {
    var name : String
}

struct SetProfileSingleMsg : Action {
    var singleMsg : Bool
}

struct SetProfileUpdating : Action {
    var updating : Bool
}

struct SetProfileSaved : Action {
    var saved : Bool
}

struct SetProfileErrorMsg : Action {
    var errorMsg : String
}
