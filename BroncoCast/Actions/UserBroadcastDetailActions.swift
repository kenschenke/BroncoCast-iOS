//
//  UserBroadcastDetailActions.swift
//  BroncoCast
//
//  Created by Ken Schenke on 1/1/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift

struct SetUserBroadcastDetailSentBy : Action {
    var sentBy : String
}

struct SetUserBroadcastDetailDelivered : Action {
    var delivered : String
}

struct SetUserBroadcastDetailShortMsg : Action {
    var shortMsg : String
}

struct SetUserBroadcastDetailLongMsg : Action {
    var longMsg : String
}
