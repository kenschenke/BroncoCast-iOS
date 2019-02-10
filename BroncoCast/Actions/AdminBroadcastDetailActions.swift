//
//  AdminBroadcastDetailActions.swift
//  BroncoCast
//
//  Created by Ken Schenke on 2/8/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift

struct SetAdminBroadcastDetails : Action {
    var broadcastId : Int
    var sentBy : String
    var time : String
    var timestamp : Int
    var isDelivered : Bool
    var isCancelled : Bool
    var shortMsg : String
    var longMsg : String
    var recipients : [String]
}
