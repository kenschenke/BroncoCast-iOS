//
//  AdminGroupNameActions.swift
//  BroncoCast
//
//  Created by Ken Schenke on 2/3/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift

struct SetAdminGroupNameId : Action {
    var groupId : Int
}

struct SetAdminGroupName : Action {
    var groupName : String
}

struct SetAdminGroupNameSaving : Action {
    var saving : Bool
}

struct SetAdminGroupNameSavingErrorMsg : Action {
    var errorMsg : String
}

struct SetAdminGroupNameGoBack : Action {
    var goBack : Bool
}
