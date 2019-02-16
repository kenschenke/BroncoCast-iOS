//
//  AppReducer.swift
//  BroncoCast
//
//  Created by Ken Schenke on 12/26/18.
//  Copyright © 2018 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift

func appReducer(_ action: Action, _ state : AppState?) -> AppState {
    return AppState(
        navigationState: navigationReducer(action, state: state?.navigationState),
        signInState: signInReducer(action, state: state?.signInState),
        registrationState: registrationReducer(action, state: state?.registrationState),
        profileOrgsState: profileOrgsReducer(action, state: state?.profileOrgsState),
        profileNameState: profileNameReducer(action, state: state?.profileNameState),
        profileContactsState: profileContactsReducer(action, state: state?.profileContactsState),
        profileContactsEditState: profileContactsEditReducer(action, state: state?.profileContactsEditState),
        userBroadcastsState: userBroadcastsReducer(action, state: state?.userBroadcastsState),
        userBroadcastDetailState: userBroadcastDetailReducer(action, state: state?.userBroadcastDetailState),
        adminUsersState: adminUsersReducer(action, state: state?.adminUsersState),
        adminOrgState: adminOrgReducer(action, state: state?.adminOrgState),
        adminUserDetailState: adminUserDetailReducer(action, state: state?.adminUserDetailState),
        adminGroupsState: adminGroupsReducer(action, state: state?.adminGroupsState),
        adminGroupNameState: adminGroupNameReducer(action, state: state?.adminGroupNameState),
        adminGroupDetailState: adminGroupDetailReducer(action, state: state?.adminGroupDetailState),
        adminBroadcastsState: adminBroadcastsReducer(action, state: state?.adminBroadcastsState),
        adminBroadcastDetailState: adminBroadcastDetailReducer(action, state: state?.adminBroadcastDetailState),
        adminNewBroadcastState: adminNewBroadcastReducer(action, state: state?.adminNewBroadcastState)
    )
}
