//
//  UserBroadcastsState.swift
//  BroncoCast
//
//  Created by Ken Schenke on 1/1/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift

struct UserBroadcastsState : StateType {
    var fetching = false
    var errorMsg = ""
    var broadcasts : [Broadcast] = []
}
