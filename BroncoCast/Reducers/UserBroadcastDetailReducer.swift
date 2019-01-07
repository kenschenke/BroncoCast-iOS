//
//  UserBroadcastDetailReducer.swift
//  BroncoCast
//
//  Created by Ken Schenke on 1/1/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift

func userBroadcastDetailReducer(_ action : Action, state: UserBroadcastDetailState?) -> UserBroadcastDetailState {
    var newState = state ?? UserBroadcastDetailState()
    
    if let setUserBroadcastDetailSentBy = action as? SetUserBroadcastDetailSentBy {
        newState.sentBy = setUserBroadcastDetailSentBy.sentBy
    } else if let setUserBroadcastDetailDelivered = action as? SetUserBroadcastDetailDelivered {
        newState.delivered = setUserBroadcastDetailDelivered.delivered
    } else if let setUserBroadcastDetailShortMsg = action as? SetUserBroadcastDetailShortMsg {
        newState.shortMsg = setUserBroadcastDetailShortMsg.shortMsg
    } else if let setUserBroadcaatDetailLongMsg = action as? SetUserBroadcastDetailLongMsg {
        newState.longMsg = setUserBroadcaatDetailLongMsg.longMsg
    }
    
    return newState
}

