//
//  ProfileOrgsReducer.swift
//  BroncoCast
//
//  Created by Ken Schenke on 12/30/18.
//  Copyright © 2018 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift

func profileOrgsReducer(_ action : Action, state: ProfileOrgsState?) -> ProfileOrgsState {
    var newState = state ?? ProfileOrgsState()
    
    if let setAdminOrgs = action as? SetAdminOrgs {
        newState.adminOrgs = setAdminOrgs.adminOrgs
        newState.notAdmin = setAdminOrgs.notAdmin
    }
    
    return newState
}

