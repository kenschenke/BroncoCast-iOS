//
//  AdminNewBroadcastReducer.swift
//  BroncoCast
//
//  Created by Ken Schenke on 2/8/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift

func adminNewBroadcastReducer(_ action : Action, state: AdminNewBroadcastState?) -> AdminNewBroadcastState {
    var newState = state ?? AdminNewBroadcastState()
    
    if let _ = action as? InitNewBroadcast {
        newState.goBack = false
        newState.shortMsg = ""
        newState.longMsg = ""
        newState.editingMsg = .none
        newState.recipients = []
        newState.sending = false
        newState.sendingErrorMsg = ""
        newState.fetchingGroups = false
        newState.fetchingGroupsErrorMsg = ""
        newState.groupMembers = [:]
    } else if let setAdminNewBroadcastShortMsg = action as? SetAdminNewBroadcastShortMsg {
        newState.shortMsg = setAdminNewBroadcastShortMsg.shortMsg
    } else if let setAdminNewBroadcastLongMsg = action as? SetAdminNewBroadcastLongMsg {
        newState.longMsg = setAdminNewBroadcastLongMsg.longMsg
    } else if let setAdminNewBroadcastEditingMsg = action as? SetAdminNewBroadcastEditingMsg {
        newState.editingMsg = setAdminNewBroadcastEditingMsg.editingMsg
    } else if let setAdminNewBroadcastSending = action as? SetAdminNewBroadcastSending {
        newState.sending = setAdminNewBroadcastSending.sending
    } else if let setAdminNewBroadcastSendingErrorMsg = action as? SetAdminNewBroadcastSendingErrorMsg {
        newState.sendingErrorMsg = setAdminNewBroadcastSendingErrorMsg.sendingErrorMsg
    } else if let adminNewBroadcastAddRecipient = action as? AdminNewBroadcastAddRecipient {
        // Make sure the recipient already isn't in the list
        let users = newState.recipients.filter { $0 == adminNewBroadcastAddRecipient.userId }
        if users.isEmpty {
            newState.recipients.append(adminNewBroadcastAddRecipient.userId)
        }
    } else if let adminNewBroadcastRemoveRecipient = action as? AdminNewBroadcastRemoveRecipient {
        newState.recipients = newState.recipients.filter { $0 != adminNewBroadcastRemoveRecipient.userId }
    } else if let setAdminNewBroadcastFetchingGroups = action as? SetAdminNewBroadcastFetchingGroups {
        newState.fetchingGroups = setAdminNewBroadcastFetchingGroups.fetchingGroups
    } else if let setAdminNewBroadcastFetchingGroupsErrorMsg = action as? SetAdminNewBroadcastFetchingGroupsErrorMsg {
        newState.fetchingGroupsErrorMsg = setAdminNewBroadcastFetchingGroupsErrorMsg.fetchingGroupsErrorMsg
    } else if let setAdminNewBroadcastGroupMembers = action as? SetAdminNewBroadcastGroupMembers {
        newState.groupMembers = setAdminNewBroadcastGroupMembers.groupMembers
    } else if let setAdminNewBroadcastSelectedGroup = action as? SetAdminNewBroadcastSelectedGroup {
        newState.selectedGroup = setAdminNewBroadcastSelectedGroup.selectedGroup
    } else if let setAdminNewBroadcastGoBack = action as? SetAdminNewBroadcastGoBack {
        newState.goBack = setAdminNewBroadcastGoBack.goBack
    }
    
    return newState
}


