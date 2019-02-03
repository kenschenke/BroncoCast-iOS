//
//  AdminOrgActions.swift
//  BroncoCast
//
//  Created by Ken Schenke on 1/27/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift

struct SetAdminOrg : Action {
    var adminOrgId : Int
    var adminOrgName : String
}
