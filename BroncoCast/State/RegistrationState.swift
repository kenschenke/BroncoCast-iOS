//
//  RegistrationState.swift
//  BroncoCast
//
//  Created by Ken Schenke on 2/16/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift

struct RegistrationState : StateType {
    var name = ""
    var password = ""
    var email = ""
    var phone = ""
    var registering = false
    var errorMsg = ""
}
