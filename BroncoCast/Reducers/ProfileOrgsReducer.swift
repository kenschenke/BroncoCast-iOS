//
//  ProfileOrgsReducer.swift
//  BroncoCast
//
//  Created by Ken Schenke on 12/30/18.
//  Copyright © 2018 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift

func profileOrgsReducer(_ action : Action, state: ProfileOrgsState?) -> ProfileOrgsState {
    var newState = state ?? ProfileOrgsState()
    
    if let setAdminOrgs = action as? SetAdminOrgs {
        newState.adminOrgs = setAdminOrgs.adminOrgs
        newState.notAdmin = setAdminOrgs.notAdmin
    } else if let setUserOrgs = action as? SetUserOrgs {
        newState.userOrgs = setUserOrgs.userOrgs
    } else if let setUserOrgsFetching = action as? SetUserOrgsFetching {
        newState.userOrgsFetching = setUserOrgsFetching.fetching
    } else if let setUserOrgsErrorMsg = action as? SetUserOrgsErrorMsg {
        newState.userOrgsErrorMsg = setUserOrgsErrorMsg.errorMsg
    } else if let dropUserOrg = action as? DropUserOrg {
        newState.userOrgs = newState.userOrgs.filter({(value: UserOrg) -> Bool in
            return dropUserOrg.memberId != value.MemberId
        })
    } else if let setUserOrgsJoining = action as? SetUserOrgsJoining {
        newState.joining = setUserOrgsJoining.joining
    } else if let setUserOrgsJoiningErrorMsg = action as? SetUserOrgsJoiningErrorMsg {
        newState.joiningErrorMsg = setUserOrgsJoiningErrorMsg.joiningErrorMsg
    } else if let setJoinTag = action as? SetJoinTag {
        newState.joinTag = setJoinTag.joinTag
    } else if let addUserOrg = action as? AddUserOrg {
        newState.userOrgs.append(UserOrg(
            OrgId: addUserOrg.OrgId,
            OrgName: addUserOrg.OrgName,
            IsAdmin: addUserOrg.IsAdmin,
            MemberId: addUserOrg.MemberId
        ))
    } else if let setDropMemberId = action as? SetDropMemberId {
        newState.dropMemberId = setDropMemberId.memberId
    } else if let setDropping = action as? SetDropping {
        newState.dropping = setDropping.dropping
    } else if let setDroppingErrorMsg = action as? SetDroppingErrorMsg {
        newState.droppingErrorMsg = setDroppingErrorMsg.droppingErrorMsg
    }
    
    return newState
}

