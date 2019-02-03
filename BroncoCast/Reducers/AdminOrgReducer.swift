//
//  AdminOrgReducer.swift
//  BroncoCast
//
//  Created by Ken Schenke on 1/27/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift

func adminOrgReducer(_ action : Action, state: AdminOrgState?) -> AdminOrgState {
    var newState = state ?? AdminOrgState()
    
    if let setAdminOrg = action as? SetAdminOrg {
        newState.adminOrgId = setAdminOrg.adminOrgId
        newState.adminOrgName = setAdminOrg.adminOrgName
    }
    
    return newState
}

