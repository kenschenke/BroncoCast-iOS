//
//  ProfileOrgsState.swift
//  BroncoCast
//
//  Created by Ken Schenke on 12/30/18.
//  Copyright © 2018 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift

struct AdminOrg {
    var AdminDefault = false
    var OrgId = 0
    var DefaultTZ = ""
    var OrgName = ""
}

struct ProfileOrgsState : StateType {
    var adminOrgs : [AdminOrg] = []
    var notAdmin = false
}
