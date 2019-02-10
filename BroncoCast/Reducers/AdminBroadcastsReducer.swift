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
    } else if let addNewBroadcast = action as? AddNewBroadcast {
        newState.broadcasts.append(AdminBroadcast(
            BroadcastId: addNewBroadcast.broadcastId,
            SentBy: addNewBroadcast.usrName,
            Time: addNewBroadcast.time,
            Timestamp: addNewBroadcast.timestamp,
            IsDelivered: addNewBroadcast.isDelivered,
            IsCancelled: false,
            ShortMsg: addNewBroadcast.shortMsg,
            LongMsg: addNewBroadcast.longMsg,
            Recipients: addNewBroadcast.recipients
        ))

        newState.broadcasts.sort(by: { $0.Timestamp >= $1.Timestamp })
    } else if let setBroadcastCancelled = action as? SetBroadcastCancelled {
        newState.broadcasts = newState.broadcasts.map({(value: AdminBroadcast) -> AdminBroadcast in
            return AdminBroadcast(
                BroadcastId: value.BroadcastId,
                SentBy: value.SentBy,
                Time: value.Time,
                Timestamp: value.Timestamp,
                IsDelivered: value.IsDelivered,
                IsCancelled: setBroadcastCancelled.broadcastId == value.BroadcastId ? true : value.IsCancelled,
                ShortMsg: value.ShortMsg,
                LongMsg: value.LongMsg,
                Recipients: value.Recipients
            )
        })
    }
    
    return newState
}
