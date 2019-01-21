//
//  ProfileContactsEditState.swift
//  BroncoCast
//
//  Created by Ken Schenke on 1/20/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift

struct ProfileContactsEditState : StateType {
    var contactId = 0  // for the currently edited contact
    var contactName = "" // for the currently edited contact
    var saving = false
    var errorMsg = ""
    var goBack = false
    var deleting = false
    var testing = false
    var testSent = false
}
