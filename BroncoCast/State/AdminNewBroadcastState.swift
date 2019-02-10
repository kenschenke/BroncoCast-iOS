//
//  AdminNewBroadcastState.swift
//  BroncoCast
//
//  Created by Ken Schenke on 2/8/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift

struct BroadcastGroupMember : Equatable {
    var UserId : Int
    var UserName : String
}

enum AdminNewBroadcastEditingMsg {
    case none
    case shortMsg
    case longMsg
}

struct AdminNewBroadcastState : StateType {
    var goBack = false
    var shortMsg = ""
    var longMsg = ""
    var editingMsg : AdminNewBroadcastEditingMsg = .none
    var recipients : [Int] = []
    var sending = false
    var groupMembers : [String : [BroadcastGroupMember]] = [:]
    var selectedGroup = ""
    var sendingErrorMsg = ""
    var fetchingGroups = false
    var fetchingGroupsErrorMsg = ""
}

