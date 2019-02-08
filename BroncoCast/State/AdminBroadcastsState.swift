//
//  AdminBroadcastsState.swift
//  BroncoCast
//
//  Created by Ken Schenke on 2/7/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift

struct AdminBroadcast : Equatable {
    var BroadcastId : Int
    var SentBy : String
    var Time : String
    var Timestamp : Int
    var IsDelivered : Bool
    var IsCancelled : Bool
    var ShortMsg : String
    var LongMsg : String
    var Recipients : [String]
}

struct AdminBroadcastsState : StateType {
    var fetchingBroadcasts = false
    var fetchingBroadcastsErrorMsg = ""
    var broadcasts : [AdminBroadcast] = []
}
