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
        profileOrgsState: profileOrgsReducer(action, state: state?.profileOrgsState),
        profileNameState: profileNameReducer(action, state: state?.profileNameState),
        userBroadcastsState: userBroadcastsReducer(action, state: state?.userBroadcastsState),
        userBroadcastDetailState: userBroadcastDetailReducer(action, state: state?.userBroadcastDetailState)
    )
}
