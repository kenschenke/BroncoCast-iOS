//
//  AdminBroadcastDetailReducer.swift
//  BroncoCast
//
//  Created by Ken Schenke on 2/8/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift

func adminBroadcastDetailReducer(_ action : Action, state: AdminBroadcastDetailState?) -> AdminBroadcastDetailState {
    var newState = state ?? AdminBroadcastDetailState()
    
    if let setAdminBroadcastDetails = action as? SetAdminBroadcastDetails {
        newState.broadcastId = setAdminBroadcastDetails.broadcastId
        newState.sentBy = setAdminBroadcastDetails.sentBy
        newState.time = setAdminBroadcastDetails.time
        newState.timestamp = setAdminBroadcastDetails.timestamp
        newState.isDelivered = setAdminBroadcastDetails.isDelivered
        newState.isCancelled = setAdminBroadcastDetails.isCancelled
        newState.shortMsg = setAdminBroadcastDetails.shortMsg
        newState.longMsg = setAdminBroadcastDetails.longMsg
        newState.recipients = setAdminBroadcastDetails.recipients
        newState.cancelling = false
        newState.cancellingErrorMsg = ""
    }
    
    return newState
}
