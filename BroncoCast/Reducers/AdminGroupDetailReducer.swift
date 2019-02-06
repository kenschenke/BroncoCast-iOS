//
//  AdminGroupDetailReducer.swift
//  BroncoCast
//
//  Created by Ken Schenke on 2/4/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift

func adminGroupDetailReducer(_ action : Action, state: AdminGroupDetailState?) -> AdminGroupDetailState {
    var newState = state ?? AdminGroupDetailState()
    
    if let setAdminGroupDetailGroupId = action as? SetAdminGroupDetailGroupId {
        newState.groupId = setAdminGroupDetailGroupId.groupId
    } else if let setAdminGroupDetailGroupName = action as? SetAdminGroupDetailGroupName {
        newState.groupName = setAdminGroupDetailGroupName.groupName
    } else if let setAdminGroupDetailMembers = action as? SetAdminGroupDetailMembers {
        newState.members = setAdminGroupDetailMembers.members
    } else if let setAdminGroupDetailFetching = action as? SetAdminGroupDetailFetching {
        newState.fetching = setAdminGroupDetailFetching.fetching
    } else if let setAdminGroupDetailFetchingErrorMsg = action as? SetAdminGroupDetailFetchingErrorMsg {
        newState.fetchingErrorMsg = setAdminGroupDetailFetchingErrorMsg.fetchingErrorMsg
    } else if let setAdminGroupDetailDeleting = action as? SetAdminGroupDetailDeleting {
        newState.deleting = setAdminGroupDetailDeleting.deleting
    } else if let setAdminGroupDetailDeletingErrorMsg = action as? SetAdminGroupDetailDeletingErrorMsg {
        newState.deletingErrorMsg = setAdminGroupDetailDeletingErrorMsg.deletingErrorMsg
    } else if let initAdminGroupDetail = action as? InitAdminGroupDetail {
        newState.groupId = initAdminGroupDetail.groupId
        newState.groupName = initAdminGroupDetail.groupName
        newState.members = []
        newState.fetching = false
        newState.fetchingErrorMsg = ""
        newState.deleting = false
        newState.deletingErrorMsg = ""
        newState.goBack = false
    } else if let setAdminGroupDetailGoBack = action as? SetAdminGroupDetailGoBack {
        newState.goBack = setAdminGroupDetailGoBack.goBack
    }
    
    return newState
}

