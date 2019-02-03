//
//  AdminUserDetailState.swift
//  BroncoCast
//
//  Created by Ken Schenke on 2/2/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift

struct AdminUserDetailState : StateType {
    var memberId = 0
    var userName = ""
    var isHidden = false
    var isAdmin = false
    var isApproved = false
    var contacts : [UserContact] = []
    var goBack = false
    var hidingUser = false
    var hidingErrorMsg = ""
    var settingAdmin = false
    var settingAdminErrorMsg = ""
    var savingName = false
    var savingNameErrorMsg = ""
    var nameSaved = false
    var removing = false
    var removingErrorMsg = ""
    var approving = false
    var approvingErrorMsg = ""
    var approveSuccess = false // set to true on successful approval
}
