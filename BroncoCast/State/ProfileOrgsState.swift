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

struct UserOrg : Equatable {
    var OrgId = 0
    var OrgName = ""
    var IsAdmin = false
    var MemberId = 0
}

struct ProfileOrgsState : StateType {
    var adminOrgs : [AdminOrg] = []
    var notAdmin = false
    var userOrgs : [UserOrg] = []
    var userOrgsFetching = false
    var userOrgsErrorMsg = ""
    var joinTag = ""
    var joining = false
    var joiningErrorMsg = ""
    var dropMemberId = 0
    var dropping = false
    var droppingErrorMsg = ""
}
