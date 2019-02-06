//
//  InitialState.swift
//  BroncoCast
//
//  Created by Ken Schenke on 12/26/18.
//  Copyright © 2018 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift

struct AppState : StateType {
    var navigationState: NavigationState
    var signInState : SignInState
    var profileOrgsState : ProfileOrgsState
    var profileNameState : ProfileNameState
    var profileContactsState : ProfileContactsState
    var profileContactsEditState : ProfileContactsEditState
    var userBroadcastsState : UserBroadcastsState
    var userBroadcastDetailState : UserBroadcastDetailState
    var adminUsersState : AdminUsersState
    var adminOrgState : AdminOrgState
    var adminUserDetailState : AdminUserDetailState
    var adminGroupsState : AdminGroupsState
    var adminGroupNameState : AdminGroupNameState
    var adminGroupDetailState : AdminGroupDetailState
}
