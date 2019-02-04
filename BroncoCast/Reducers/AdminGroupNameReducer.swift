//
//  AdminGroupNameReducer.swift
//  BroncoCast
//
//  Created by Ken Schenke on 2/3/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift

func adminGroupNameReducer(_ action : Action, state: AdminGroupNameState?) -> AdminGroupNameState {
    var newState = state ?? AdminGroupNameState()
    
    if let setAdminGroupName = action as? SetAdminGroupName {
        newState.groupName = setAdminGroupName.groupName
    } else if let setAdminGroupNameId = action as? SetAdminGroupNameId {
        newState.groupId = setAdminGroupNameId.groupId
    } else if let setAdminGroupNameSaving = action as? SetAdminGroupNameSaving {
        newState.saving = setAdminGroupNameSaving.saving
    } else if let setAdminGroupNameSavingErrorMsg = action as? SetAdminGroupNameSavingErrorMsg {
        newState.savingErrorMsg = setAdminGroupNameSavingErrorMsg.errorMsg
    } else if let setAdminGroupNameGoBack = action as? SetAdminGroupNameGoBack {
        newState.goBack = setAdminGroupNameGoBack.goBack
    }
    
    return newState
}

