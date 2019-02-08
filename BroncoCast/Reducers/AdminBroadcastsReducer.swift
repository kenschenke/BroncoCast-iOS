//
//  AdminBroadcastsReducer.swift
//  BroncoCast
//
//  Created by Ken Schenke on 2/7/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift

func adminBroadcastsReducer(_ action : Action, state: AdminBroadcastsState?) -> AdminBroadcastsState {
    var newState = state ?? AdminBroadcastsState()
    
    if let setAdminBroadcasts = action as? SetAdminBroadcasts {
        newState.broadcasts = setAdminBroadcasts.broadcasts
    } else if let setAdminBroadcastsFetching = action as? SetAdminBroadcastsFetching {
        newState.fetchingBroadcasts = setAdminBroadcastsFetching.fetching
    } else if let setAdminBroadcastsFetchingErrorMsg = action as? SetAdminBroadcastsFetchingErrorMsg {
        newState.fetchingBroadcastsErrorMsg = setAdminBroadcastsFetchingErrorMsg.fetchingErrorMsg
    }
    
    return newState
}
