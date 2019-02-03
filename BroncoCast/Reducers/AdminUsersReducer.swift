//
//  AdminUsersReducer.swift
//  BroncoCast
//
//  Created by Ken Schenke on 1/27/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift

func filterAdminUsers(adminUsersState : inout AdminUsersState) {
    adminUsersState.numUnapprovedUsers = 0
    adminUsersState.numDeliveryProblems = 0
    
    adminUsersState.filteredUsers = adminUsersState.users.filter {
        if !$0.Approved {
            adminUsersState.numUnapprovedUsers += 1
        }
        if $0.HasDeliveryError {
            adminUsersState.numDeliveryProblems += 1
        }
    
        return adminUsersState.showHiddenUsers || !$0.Hidden
    }
    
    adminUsersState.filteredUsers.sort(by: {
        if $0.Hidden && !$1.Hidden {
            return true
        } else if !$0.Hidden && $1.Hidden {
            return false
        } else if $0.Hidden && $1.Hidden {
            return $0.UserName < $1.UserName
        } else if !$0.Approved && $1.Approved {
            return true
        } else if $0.Approved && !$1.Approved {
            return false
        } else if !$0.Approved && !$1.Approved {
            return $0.UserName < $1.UserName
        } else if $0.HasDeliveryError && !$1.HasDeliveryError {
            return true
        } else if !$0.HasDeliveryError && $1.HasDeliveryError {
            return false
        }
        
        return $0.UserName < $1.UserName
    })
}

func adminUsersReducer(_ action : Action, state: AdminUsersState?) -> AdminUsersState {
    var newState = state ?? AdminUsersState()
    
    if let setAdminUsers = action as? SetAdminUsers {
        newState.users = setAdminUsers.users
        filterAdminUsers(adminUsersState: &newState)
    } else if let setAdminUsersFetching = action as? SetAdminUsersFetching {
        newState.fetching = setAdminUsersFetching.fetching
    } else if let setAdminUsersFetchingErrorMsg = action as? SetAdminUsersFetchingErrorMsg {
        newState.fetchingErrorMsg = setAdminUsersFetchingErrorMsg.errorMsg
    } else if let setShowHiddenUsers = action as? SetShowHiddenUsers {
        newState.showHiddenUsers = setShowHiddenUsers.showHiddenUsers
        filterAdminUsers(adminUsersState: &newState)
    } else if let hideUnhideUser = action as? HideUnhideUser {
        newState.users = (state?.users ?? []).map({(value: AdminUser) -> AdminUser in
            if value.MemberId == hideUnhideUser.memberId {
                return AdminUser(
                    UserId: value.UserId,
                    UserName: value.UserName,
                    MemberId: value.MemberId,
                    IsAdmin: value.IsAdmin,
                    Approved: value.Approved,
                    Hidden: hideUnhideUser.isHidden,
                    Groups: value.Groups,
                    Contacts: value.Contacts,
                    SmsLogs : value.SmsLogs,
                    HasDeliveryError: value.HasDeliveryError
                )
            }
            return value
        })
        filterAdminUsers(adminUsersState: &newState)
    } else if let setClearUserAdmin = action as? SetClearUserAdmin {
        newState.users = (state?.users ?? []).map({(value: AdminUser) -> AdminUser in
            if value.MemberId == setClearUserAdmin.memberId {
                return AdminUser(
                    UserId: value.UserId,
                    UserName: value.UserName,
                    MemberId: value.MemberId,
                    IsAdmin: setClearUserAdmin.isAdmin,
                    Approved: value.Approved,
                    Hidden: value.Hidden,
                    Groups: value.Groups,
                    Contacts: value.Contacts,
                    SmsLogs : value.SmsLogs,
                    HasDeliveryError: value.HasDeliveryError
                )
            }
            return value
        })
        filterAdminUsers(adminUsersState: &newState)
    } else if let setUserName = action as? SetUserName {
        newState.users = (state?.users ?? []).map({(value: AdminUser) -> AdminUser in
            if value.MemberId == setUserName.memberId {
                return AdminUser(
                    UserId: value.UserId,
                    UserName: setUserName.userName,
                    MemberId: value.MemberId,
                    IsAdmin: value.IsAdmin,
                    Approved: value.Approved,
                    Hidden: value.Hidden,
                    Groups: value.Groups,
                    Contacts: value.Contacts,
                    SmsLogs : value.SmsLogs,
                    HasDeliveryError: value.HasDeliveryError
                )
            }
            return value
        })
        filterAdminUsers(adminUsersState: &newState)
    } else if let removeUser = action as? RemoveUser {
        newState.users = (state?.users ?? []).filter { $0.MemberId != removeUser.memberId }
        filterAdminUsers(adminUsersState: &newState)
    } else if let approveUser = action as? ApproveUser {
        newState.users = (state?.users ?? []).map({(value: AdminUser) -> AdminUser in
            if value.MemberId == approveUser.memberId {
                return AdminUser(
                    UserId: value.UserId,
                    UserName: value.UserName,
                    MemberId: value.MemberId,
                    IsAdmin: value.IsAdmin,
                    Approved: true,
                    Hidden: value.Hidden,
                    Groups: value.Groups,
                    Contacts: value.Contacts,
                    SmsLogs : value.SmsLogs,
                    HasDeliveryError: value.HasDeliveryError
                )
            }
            return value
        })
        filterAdminUsers(adminUsersState: &newState)
    }
    
    return newState
}

