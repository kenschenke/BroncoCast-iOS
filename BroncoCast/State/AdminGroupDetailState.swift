//
//  AdminGroupDetailState.swift
//  BroncoCast
//
//  Created by Ken Schenke on 2/4/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift

struct GroupMember : Equatable {
    var MemberId = 0
    var MemberName = ""
}

struct NonMember : Equatable {
    var UserId = 0
    var UserName = ""
}

struct AdminGroupDetailState : StateType {
    var groupId = 0
    var groupName = ""
    var members : [GroupMember] = []
    var nonMembers : [NonMember] = []
    var fetching = false
    var fetchingErrorMsg = ""
    var deleting = false
    var deletingErrorMsg = ""
    var goBack = false
    var fetchingNonMembers = false
    var fetchingNonMembersErrorMsg = ""
    var adding = false
    var addingErrorMsg = ""
    var addingUserId = 0
}
