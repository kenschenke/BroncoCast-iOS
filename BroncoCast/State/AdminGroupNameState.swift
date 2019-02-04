//
//  AdminGroupNameState.swift
//  BroncoCast
//
//  Created by Ken Schenke on 2/3/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift

struct AdminGroupNameState : StateType {
    var groupId = 0
    var groupName = ""
    var saving = false
    var savingErrorMsg = ""
    var goBack = false
}
