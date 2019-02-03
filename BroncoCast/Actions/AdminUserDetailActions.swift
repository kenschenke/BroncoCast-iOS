//
//  AdminUserDetailActions.swift
//  BroncoCast
//
//  Created by Ken Schenke on 2/2/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift
import Alamofire
import SwiftyJSON

struct SetAdminUserDetailInit : Action {
    var memberId : Int
    var userName : String
    var isHidden : Bool
    var isAdmin : Bool
    var isApproved : Bool
    var contacts : [UserContact]
}

struct SetAdminUserName : Action {
    var userName : String
}

struct SetAdminUserNavBack : Action {
    var goBack : Bool
}

struct SetAdminUserHiding : Action {
    var hidingUser : Bool
}

struct SetAdminUserHidingErrorMsg : Action {
    var hidingUserErrorMsg : String
}

struct SetAdminUserHidden : Action {
    var isHidden : Bool
}

struct SetAdminUserSettingAdmin : Action {
    var settingAdmin : Bool
}

struct SetAdminUserSettingAdminErrorMsg : Action {
    var settingAdminErrorMsg : String
}

struct SetAdminUserAdmin : Action {
    var isAdmin : Bool
}

struct HideUnhideUser : Action {
    var memberId : Int
    var isHidden : Bool
}

struct SetClearUserAdmin : Action {
    var memberId : Int
    var isAdmin : Bool
}

struct SetAdminUserSavingName : Action {
    var savingName : Bool
}

struct SetAdminUserSavingNameErrorMsg : Action {
    var savingNameErrorMsg : String
}

struct SetAdminUserNameSaved : Action {
    var nameSaved : Bool
}

struct SetUserName : Action {
    var memberId : Int
    var userName : String
}

struct SetAdminUserRemoving : Action {
    var removing : Bool
}

struct SetAdminUserRemovingErrorMsg : Action {
    var removingErrorMsg : String
}

struct RemoveUser : Action {
    var memberId : Int
}

struct SetAdminUserApproving : Action {
    var approving : Bool
}

struct SetAdminUserApprovingErrorMsg : Action {
    var approvingErrorMsg : String
}

struct SetAdminUserApproveSuccess : Action {
    var approveSuccess : Bool
}

struct SetAdminUserIsApproved : Action {
    var isApproved : Bool
}

struct ApproveUser : Action {
    var memberId : Int
}

func adminHideUser(state : AppState, store : Store<AppState>) -> Action? {
    store.dispatch(SetAdminUserHiding(hidingUser: true))
    store.dispatch(SetAdminUserHidingErrorMsg(hidingUserErrorMsg: ""))
    
    let isHidden = state.adminUserDetailState.isHidden
    let memberId = state.adminUserDetailState.memberId
    let url = UrlMaker.makeUrl(isHidden ? .admin_users_unhide : .admin_users_hide) +
        "/\(memberId)"
    Alamofire.request(url, method: .put).responseJSON {
        response in
        store.dispatch(SetAdminUserHiding(hidingUser: false))
        if response.result.isSuccess {
            let responseJSON : JSON = JSON(response.result.value!)
            
            if responseJSON["Success"].bool ?? false {
                store.dispatch(SetAdminUserHidden(isHidden: !isHidden))
                store.dispatch(HideUnhideUser(memberId: memberId, isHidden: !isHidden))
            } else {
                store.dispatch(SetAdminUserHidingErrorMsg(hidingUserErrorMsg: responseJSON["Error"].string ?? ""))
            }
        } else {
            store.dispatch(SetDroppingErrorMsg(droppingErrorMsg: "Unable to hide user"))
        }
    }
 
    return nil
}

func adminUserSetAdmin(state : AppState, store : Store<AppState>) -> Action? {
    store.dispatch(SetAdminUserSettingAdmin(settingAdmin: true))
    store.dispatch(SetAdminUserSettingAdminErrorMsg(settingAdminErrorMsg: ""))
    
    let isAdmin = state.adminUserDetailState.isAdmin
    let memberId = state.adminUserDetailState.memberId
    let url = UrlMaker.makeUrl(.admin_users_admin) + "/\(memberId)"
    Alamofire.request(url, method: isAdmin ? .delete : .put).responseJSON {
        response in
        store.dispatch(SetAdminUserSettingAdmin(settingAdmin: false))
        if response.result.isSuccess {
            let responseJSON : JSON = JSON(response.result.value!)
            
            if responseJSON["Success"].bool ?? false {
                store.dispatch(SetAdminUserAdmin(isAdmin: !isAdmin))
                store.dispatch(SetClearUserAdmin(memberId: memberId, isAdmin: !isAdmin))
            } else {
                store.dispatch(SetAdminUserSettingAdminErrorMsg(settingAdminErrorMsg: responseJSON["Error"].string ?? ""))
            }
        } else {
            store.dispatch(SetAdminUserSettingAdminErrorMsg(settingAdminErrorMsg: "Unable to set admin"))
        }
    }
 
    return nil
}

func adminUserSaveName(state : AppState, store : Store<AppState>) -> Action? {
    store.dispatch(SetAdminUserNameSaved(nameSaved: false))
    store.dispatch(SetAdminUserSavingName(savingName: true))
    store.dispatch(SetAdminUserSavingNameErrorMsg(savingNameErrorMsg: ""))
    
    let memberId = state.adminUserDetailState.memberId
    let userName = state.adminUserDetailState.userName
    let url = UrlMaker.makeUrl(.admin_users_name) + "/\(memberId)"
    let params : [String : String] = [
        "Name" : userName,
    ]
    Alamofire.request(url, method: .post, parameters: params).responseJSON {
        response in
        store.dispatch(SetAdminUserSavingName(savingName: false))
        if response.result.isSuccess {
            let responseJSON : JSON = JSON(response.result.value!)
            
            if responseJSON["Success"].bool ?? false {
                store.dispatch(SetAdminUserNameSaved(nameSaved: true))
                store.dispatch(SetUserName(memberId: memberId, userName: userName))
            } else {
                store.dispatch(SetAdminUserSavingNameErrorMsg(savingNameErrorMsg: responseJSON["Error"].string ?? ""))
            }
        } else {
            store.dispatch(SetAdminUserSavingNameErrorMsg(savingNameErrorMsg: "Unable to save name"))
        }
    }
 
    return nil
}

func adminRemoveUser(state : AppState, store : Store<AppState>) -> Action? {
    store.dispatch(SetAdminUserRemoving(removing: true))
    store.dispatch(SetAdminUserRemovingErrorMsg(removingErrorMsg: ""))
    
    let memberId = state.adminUserDetailState.memberId
    let url = UrlMaker.makeUrl(.admin_users_remove) + "/\(memberId)"
    Alamofire.request(url, method: .delete).responseJSON {
        response in
        store.dispatch(SetAdminUserRemoving(removing: false))
        if response.result.isSuccess {
            let responseJSON : JSON = JSON(response.result.value!)
            
            if responseJSON["Success"].bool ?? false {
                store.dispatch(RemoveUser(memberId: memberId))
                store.dispatch(SetAdminUserNavBack(goBack: true))
            } else {
                store.dispatch(SetAdminUserRemovingErrorMsg(removingErrorMsg: responseJSON["Error"].string ?? ""))
            }
        } else {
            store.dispatch(SetAdminUserRemovingErrorMsg(removingErrorMsg: "Unable to remove user"))
        }
    }
    
    return nil
}

func adminApproveUser(state : AppState, store : Store<AppState>) -> Action? {
    store.dispatch(SetAdminUserApproving(approving: true))
    store.dispatch(SetAdminUserApprovingErrorMsg(approvingErrorMsg: ""))
    
    let memberId = state.adminUserDetailState.memberId
    
    let url = UrlMaker.makeUrl(.admin_users_approve) + "/\(memberId)"
    Alamofire.request(url, method: .put).responseJSON {
        response in
        store.dispatch(SetAdminUserApproving(approving: false))
        if response.result.isSuccess {
            let responseJSON : JSON = JSON(response.result.value!)
            
            if responseJSON["Success"].bool ?? false {
                store.dispatch(SetAdminUserIsApproved(isApproved: true))
                store.dispatch(SetAdminUserApproveSuccess(approveSuccess: true))
                store.dispatch(ApproveUser(memberId: memberId))
            } else {
                store.dispatch(SetAdminUserApprovingErrorMsg(approvingErrorMsg: responseJSON["Error"].string ?? ""))
            }
        } else {
            store.dispatch(SetAdminUserApprovingErrorMsg(approvingErrorMsg: "Unable to approve user"))
        }
    }
    
    return nil
}
