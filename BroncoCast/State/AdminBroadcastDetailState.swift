//
//  AdminBroadcastDetailState.swift
//  BroncoCast
//
//  Created by Ken Schenke on 2/8/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift

struct AdminBroadcastDetailState : StateType {
    var broadcastId = 0
    var time = ""
    var timestamp = 0
    var isDelivered = false
    var isCancelled = false
    var sentBy = ""
    var shortMsg = ""
    var longMsg = ""
    var recipients : [String] = []
    var cancelling = false
    var cancellingErrorMsg = ""
}
