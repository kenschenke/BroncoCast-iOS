//
//  AdminGroupsReducer.swift
//  BroncoCast
//
//  Created by Ken Schenke on 2/3/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift

func adminGroupsReducer(_ action : Action, state: AdminGroupsState?) -> AdminGroupsState {
    var newState = state ?? AdminGroupsState()
    
    if let setAdminGroups = action as? SetAdminGroups {
        newState.groups = setAdminGroups.groups
        newState.groups.sort(by: { $0.GroupName < $1.GroupName })
    } else if let setAdminGroupsFetching = action as? SetAdminGroupsFetching {
        newState.fetching = setAdminGroupsFetching.fetching
    } else if let setAdminGroupsFetchingErrorMsg = action as? SetAdminGroupsFetchingErrorMsg {
        newState.fetchingErrorMsg = setAdminGroupsFetchingErrorMsg.fetchingErrorMsg
    } else if let addNewGroup = action as? AddNewGroup {
        newState.groups.append(Group(
            GroupId: addNewGroup.groupId,
            GroupName: addNewGroup.groupName
        ))
        newState.groups.sort(by: { $0.GroupName < $1.GroupName })
    } else if let renameGroup = action as? RenameGroup {
        newState.groups = (state?.groups ?? []).map({(value: Group) -> Group in
            if value.GroupId == renameGroup.groupId {
                return Group(
                    GroupId: value.GroupId,
                    GroupName: renameGroup.groupName
                )
            }
            return value
        })
        newState.groups.sort(by: { $0.GroupName < $1.GroupName })
    }
    
    return newState
}

