//
//  ProfileContactsReducer.swift
//  BroncoCast
//
//  Created by Ken Schenke on 1/19/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift

func profileContactsReducer(_ action : Action, state: ProfileContactsState?) -> ProfileContactsState {
    var newState = state ?? ProfileContactsState()
    
    if let setProfileContactsFetching = action as? SetProfileContactsFetching {
        newState.fetching = setProfileContactsFetching.fetching
    } else if let setProfileContactsErrorMsg = action as? SetProfileContactsErrorMsg {
        newState.errorMsg = setProfileContactsErrorMsg.errorMsg
    } else if let setProfileContactsContacts = action as? SetProfileContactsContacts {
        newState.contacts = setProfileContactsContacts.contacts
    } else if let updateProfileContact = action as? UpdateProfileContact {
        newState.contacts = newState.contacts.map({(value: Contact) -> Contact in
            if value.contactId == updateProfileContact.contactId {
                return Contact(contactId: value.contactId, contact: updateProfileContact.contactName)
            }
            return value
        })
    } else if let addProfileContact = action as? AddProfileContact {
        newState.contacts.append(Contact(contactId: addProfileContact.contactId,
                                         contact: addProfileContact.contactName))
    } else if let deleteProfileContact = action as? DeleteProfileContact {
        newState.contacts = newState.contacts.filter({(value: Contact) -> Bool in
            return deleteProfileContact.contactId != value.contactId
        })
    }
 
    return newState
}


