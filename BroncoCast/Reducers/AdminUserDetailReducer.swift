//
//  AdminUserDetailReducer.swift
//  BroncoCast
//
//  Created by Ken Schenke on 2/2/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift

func adminUserDetailReducer(_ action : Action, state: AdminUserDetailState?) -> AdminUserDetailState {
    var newState = state ?? AdminUserDetailState()
    
    if let setAdminUserDetailInit = action as? SetAdminUserDetailInit {
        newState.memberId = setAdminUserDetailInit.memberId
        newState.userName = setAdminUserDetailInit.userName
        newState.isHidden = setAdminUserDetailInit.isHidden
        newState.isAdmin = setAdminUserDetailInit.isAdmin
        newState.isApproved = setAdminUserDetailInit.isApproved
        newState.contacts = setAdminUserDetailInit.contacts
        newState.goBack = false
        newState.hidingUser = false
        newState.hidingErrorMsg = ""
        newState.settingAdmin = false
        newState.settingAdminErrorMsg = ""
        newState.savingName = false
        newState.savingNameErrorMsg = ""
        newState.nameSaved = false
        newState.removing = false
        newState.removingErrorMsg = ""
        newState.approving = false
        newState.approvingErrorMsg = ""
        newState.approveSuccess = false
    } else if let setAdminUserName = action as? SetAdminUserName {
        newState.userName = setAdminUserName.userName
    } else if let setAdminUserNavBack = action as? SetAdminUserNavBack {
        newState.goBack = setAdminUserNavBack.goBack
    } else if let setAdminUserHiding = action as? SetAdminUserHiding {
        newState.hidingUser = setAdminUserHiding.hidingUser
    } else if let setAdminUserHidingErrorMsg = action as? SetAdminUserHidingErrorMsg {
        newState.hidingErrorMsg = setAdminUserHidingErrorMsg.hidingUserErrorMsg
    } else if let setAdminUserHidden = action as? SetAdminUserHidden {
        newState.isHidden = setAdminUserHidden.isHidden
    } else if let setAdminUserSettingAdmin = action as? SetAdminUserSettingAdmin {
        newState.settingAdmin = setAdminUserSettingAdmin.settingAdmin
    } else if let setAdminUserSettingAdminErrorMsg = action as? SetAdminUserSettingAdminErrorMsg {
        newState.settingAdminErrorMsg = setAdminUserSettingAdminErrorMsg.settingAdminErrorMsg
    } else if let setAdminUserAdmin = action as? SetAdminUserAdmin {
        newState.isAdmin = setAdminUserAdmin.isAdmin
    } else if let setAdminUserSavingName = action as? SetAdminUserSavingName {
        newState.savingName = setAdminUserSavingName.savingName
    } else if let setAdminUserSavingNameErrorMsg = action as? SetAdminUserSavingNameErrorMsg {
        newState.savingNameErrorMsg = setAdminUserSavingNameErrorMsg.savingNameErrorMsg
    } else if let setAdminUserNameSaved = action as? SetAdminUserNameSaved {
        newState.nameSaved = setAdminUserNameSaved.nameSaved
    } else if let setAdminUserRemoving = action as? SetAdminUserRemoving {
        newState.removing = setAdminUserRemoving.removing
    } else if let setAdminUserRemovingErrorMsg = action as? SetAdminUserRemovingErrorMsg {
        newState.removingErrorMsg = setAdminUserRemovingErrorMsg.removingErrorMsg
    } else if let setAdminUserApproving = action as? SetAdminUserApproving {
        newState.approving = setAdminUserApproving.approving
    } else if let setAdminUserApprovingErrorMsg = action as? SetAdminUserApprovingErrorMsg {
        newState.approvingErrorMsg = setAdminUserApprovingErrorMsg.approvingErrorMsg
    } else if let setAdminUserApproveSuccess = action as? SetAdminUserApproveSuccess {
        newState.approveSuccess = setAdminUserApproveSuccess.approveSuccess
    } else if let setAdminUserIsApproved = action as? SetAdminUserIsApproved {
        newState.isApproved = setAdminUserIsApproved.isApproved
    }
    
    return newState
}


