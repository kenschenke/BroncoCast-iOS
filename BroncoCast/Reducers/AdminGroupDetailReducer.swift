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
        newState.nonMembers = []
        newState.fetching = false
        newState.fetchingErrorMsg = ""
        newState.deleting = false
        newState.deletingErrorMsg = ""
        newState.goBack = false
        newState.fetchingNonMembers = false
        newState.fetchingNonMembersErrorMsg = ""
        newState.adding = false
        newState.addingErrorMsg = ""
        newState.addingUserId = 0
        newState.removing = false
        newState.removingErrorMsg = ""
        newState.removingMemberId = 0
    } else if let setAdminGroupDetailGoBack = action as? SetAdminGroupDetailGoBack {
        newState.goBack = setAdminGroupDetailGoBack.goBack
    } else if let setAdminGroupDetailNonMembers = action as? SetAdminGroupDetailNonMembers {
        newState.nonMembers = setAdminGroupDetailNonMembers.nonMembers
    } else if let setAdminGroupDetailFetchingNonMembers = action as? SetAdminGroupDetailFetchingNonMembers {
        newState.fetchingNonMembers = setAdminGroupDetailFetchingNonMembers.fetching
    } else if let setAdminGroupDetailFetchingNonMembersErrorMsg = action as? SetAdminGroupDetailFetchingNonMembersErrorMsg {
        newState.fetchingNonMembersErrorMsg = setAdminGroupDetailFetchingNonMembersErrorMsg.fetchingErrorMsg
    } else if let setAdminGroupDetailAdding = action as? SetAdminGroupDetailAdding {
        newState.adding = setAdminGroupDetailAdding.adding
    } else if let setAdminGroupDetailAddingErrorMsg = action as? SetAdminGroupDetailAddingErrorMsg {
        newState.addingErrorMsg = setAdminGroupDetailAddingErrorMsg.addingErrorMsg
    } else if let setAdminGroupDetailAddingUserId = action as? SetAdminGroupDetailAddingUserId {
        newState.addingUserId = setAdminGroupDetailAddingUserId.addingUserId
    } else if let addAction = action as? AddGroupMember {
        newState.members.append(GroupMember(
            MemberId: addAction.memberId,
            MemberName: addAction.userName
        ))
        newState.members.sort(by: { $0.MemberName < $1.MemberName })
        newState.nonMembers = newState.nonMembers.filter { $0.UserId != addAction.userId }
    } else if let setAdminGroupDetailRemoving = action as? SetAdminGroupDetailRemoving {
        newState.removing = setAdminGroupDetailRemoving.removing
    } else if let setAdminGroupDetailRemovingErrorMsg = action as? SetAdminGroupDetailRemovingErrorMsg {
        newState.removingErrorMsg = setAdminGroupDetailRemovingErrorMsg.removingErrorMsg
    } else if let setAdminGroupDetailRemovingMemberId = action as? SetAdminGroupDetailRemovingMemberId {
        newState.removingMemberId = setAdminGroupDetailRemovingMemberId.removingMemberId
    } else if let removeAction = action as? RemoveGroupMember {
        newState.nonMembers.append(NonMember(
            UserId: removeAction.userId,
            UserName: removeAction.userName
        ))
        newState.nonMembers.sort(by: { $0.UserName < $1.UserName })
        newState.members = newState.members.filter { $0.MemberId != removeAction.memberId }
    }
    
    return newState
}

