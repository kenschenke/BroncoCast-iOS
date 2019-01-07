//
//  UserBroadcastsReducer.swift
//  BroncoCast
//
//  Created by Ken Schenke on 1/1/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift

func userBroadcastsReducer(_ action : Action, state: UserBroadcastsState?) -> UserBroadcastsState {
    var newState = state ?? UserBroadcastsState()
    
    if let setUserBroadcastsFetching = action as? SetUserBroadcastsFetching {
        newState.fetching = setUserBroadcastsFetching.fetching
    } else if let setUserBroadcastsErrorMsg = action as? SetUserBroadcastsErrorMsg {
        newState.errorMsg = setUserBroadcastsErrorMsg.errorMsg
    } else if let setUserBroadcastsBroadcasts = action as? SetUserBroadcastsBroadcasts {
        newState.broadcasts = setUserBroadcastsBroadcasts.broadcasts
    }
    
    return newState
}

