//
//  ProfileOrgsActions.swift
//  BroncoCast
//
//  Created by Ken Schenke on 12/30/18.
//  Copyright © 2018 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift

struct SetAdminOrgs : Action {
    var adminOrgs : [AdminOrg]
    var notAdmin : Bool
}
