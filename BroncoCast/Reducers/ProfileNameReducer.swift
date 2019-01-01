//
//  ProfileNameReducer.swift
//  BroncoCast
//
//  Created by Ken Schenke on 12/31/18.
//  Copyright © 2018 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift

func profileNameReducer(_ action : Action, state: ProfileNameState?) -> ProfileNameState {
    var newState = state ?? ProfileNameState()
    
    if let setProfileGetting = action as? SetProfileGetting {
        newState.getting = setProfileGetting.getting
    } else if let setProfileName = action as? SetProfileName {
        newState.name = setProfileName.name
    } else if let setProfileSingleMsg = action as? SetProfileSingleMsg {
        newState.singleMsg = setProfileSingleMsg.singleMsg
    } else if let setProfileUpdating = action as? SetProfileUpdating {
        newState.updating = setProfileUpdating.updating
    } else if let setProfileSaved = action as? SetProfileSaved {
        newState.saved = setProfileSaved.saved
    } else if let setProfileErrorMsg = action as? SetProfileErrorMsg {
        newState.errorMsg = setProfileErrorMsg.errorMsg
    }
    
    return newState
}

