//
//  AdminUsersState.swift
//  BroncoCast
//
//  Created by Ken Schenke on 1/27/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift

struct UserContact : Equatable {
    var ContactId = 0
    var ContactName = ""
}

struct SmsLog : Equatable {
    var Code = ""
    var Message = ""
    var Time = ""
}

struct AdminUser : Equatable {
    var UserId = 0
    var UserName = ""
    var MemberId = 0
    var IsAdmin = false
    var Approved = false
    var Hidden = false
    var Groups = ""
    var Contacts : [UserContact] = []
    var SmsLogs : [SmsLog] = []
    var HasDeliveryError = false
}

struct AdminUsersState : StateType {
    var users : [AdminUser] = []
    var filteredUsers : [AdminUser] = []
    var showHiddenUsers = false
    var numUnapprovedUsers = 0
    var numDeliveryProblems = 0
    var fetching = false
    var fetchingErrorMsg = ""
}

