//
//  AdminGroupsState.swift
//  BroncoCast
//
//  Created by Ken Schenke on 2/3/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift

struct Group : Equatable {
    var GroupId : Int
    var GroupName : String
}

struct AdminGroupsState : StateType {
    var groups : [Group] = []
    var fetching = false
    var fetchingErrorMsg = ""
}
