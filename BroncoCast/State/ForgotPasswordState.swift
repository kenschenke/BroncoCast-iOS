//
//  ForgotPasswordState.swift
//  BroncoCast
//
//  Created by Ken Schenke on 2/16/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift

struct ForgotPasswordState : StateType {
    var phone = ""
    var email = ""
    var finding = false
    var findingErrorMsg = ""
    var found = false
    var recovering = false
    var recoveringErrorMsg = ""
    var password = ""
    var code = ""
    var recovered = false
}
