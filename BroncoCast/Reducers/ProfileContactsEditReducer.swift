//
//  ProfileContactsEditReducer.swift
//  BroncoCast
//
//  Created by Ken Schenke on 1/20/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift

func profileContactsEditReducer(_ action : Action, state: ProfileContactsEditState?) -> ProfileContactsEditState {
    var newState = state ?? ProfileContactsEditState()
    
    if let setProfileContactsNavBack = action as? SetProfileContactsNavBack {
        newState.goBack = setProfileContactsNavBack.goBack
    } else if let setProfileContactToEdit = action as? SetProfileContactToEdit {
        newState.contactId = setProfileContactToEdit.contactId
        newState.contactName = setProfileContactToEdit.contactName
    } else if let setProfileContactSaving = action as? SetProfileContactSaving {
        newState.saving = setProfileContactSaving.saving
    } else if let setProfileContactEditErrorMsg = action as? SetProfileContactEditErrorMsg {
        newState.errorMsg = setProfileContactEditErrorMsg.errorMsg
    } else if let deletingProfileContact = action as? SetProfileContactDeleting {
        newState.deleting = deletingProfileContact.deleting
    } else if let setProfileContactTesting = action as? SetProfileContactTesting {
        newState.testing = setProfileContactTesting.testing
    } else if let setProfileContactTestSent = action as? SetProfileContactTestSent {
        newState.testSent = setProfileContactTestSent.testSent
    }
    
    return newState
}


