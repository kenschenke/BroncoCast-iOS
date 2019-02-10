//
//  AdminNewBroadcastActions.swift
//  BroncoCast
//
//  Created by Ken Schenke on 2/8/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift
import Alamofire
import SwiftyJSON

struct InitNewBroadcast : Action {
    
}

struct AddNewBroadcast : Action {
    var broadcastId : Int
    var shortMsg : String
    var longMsg : String
    var time : String
    var timestamp : Int
    var isDelivered : Bool
    var usrName : String
    var recipients : [String]
}

struct SetAdminNewBroadcastGoBack : Action {
    var goBack : Bool
}

struct SetAdminNewBroadcastShortMsg : Action {
    var shortMsg : String
}

struct SetAdminNewBroadcastLongMsg : Action {
    var longMsg : String
}

struct SetAdminNewBroadcastEditingMsg : Action {
    var editingMsg : AdminNewBroadcastEditingMsg
}

struct AdminNewBroadcastAddRecipient : Action {
    var userId : Int
}

struct AdminNewBroadcastRemoveRecipient : Action {
    var userId : Int
}

struct SetAdminNewBroadcastSending : Action {
    var sending : Bool
}

struct SetAdminNewBroadcastSendingErrorMsg : Action {
    var sendingErrorMsg : String
}

struct SetAdminNewBroadcastFetchingGroups : Action {
    var fetchingGroups : Bool
}

struct SetAdminNewBroadcastFetchingGroupsErrorMsg : Action {
    var fetchingGroupsErrorMsg : String
}

struct SetAdminNewBroadcastGroupMembers : Action {
    var groupMembers : [String : [BroadcastGroupMember]]
}

struct SetAdminNewBroadcastSelectedGroup : Action {
    var selectedGroup : String
}

func getAdminBroadcastGroupMembers(state : AppState, store : Store<AppState>) -> Action? {
    store.dispatch(SetAdminNewBroadcastFetchingGroups(fetchingGroups: true))
    store.dispatch(SetAdminNewBroadcastFetchingGroupsErrorMsg(fetchingGroupsErrorMsg: ""))
    
    let url = UrlMaker.makeUrl(.admin_broadcasts_groups) + "/\(state.adminOrgState.adminOrgId)"
    Alamofire.request(url, method: .get).responseJSON {
        response in
        store.dispatch(SetAdminNewBroadcastFetchingGroups(fetchingGroups: false))
        
        var groups : [String : [BroadcastGroupMember]] = [:]
        if response.result.isSuccess {
            let responseJSON : JSON = JSON(response.result.value!)
            
            if responseJSON["Success"].bool ?? false {
                if responseJSON["Groups"].dictionary != nil {
                    for (key, groupJSON):(String, JSON) in responseJSON["Groups"] {
                        var members : [BroadcastGroupMember] = []
                        if groupJSON.array != nil {
                            for (_, member) in groupJSON {
                                members.append(BroadcastGroupMember(
                                    UserId: member["UserId"].int ?? 0,
                                    UserName: member["UserName"].string ?? ""
                                ))
                            }
                        }
                        groups[key] = members
                    }
                }
            } else {
                store.dispatch(SetAdminNewBroadcastFetchingGroupsErrorMsg(
                    fetchingGroupsErrorMsg: responseJSON["Error"].string ?? ""))
            }
        } else {
            store.dispatch(SetAdminNewBroadcastFetchingGroupsErrorMsg(
                fetchingGroupsErrorMsg: "Unable to retrieve group information"))
        }
        
        store.dispatch(SetAdminNewBroadcastGroupMembers(groupMembers: groups))
    }
 
    return nil
}

func sendBroadcast(state :AppState, store :Store<AppState>) -> Action? {
    store.dispatch(SetAdminNewBroadcastSending(sending: true))
    store.dispatch(SetAdminNewBroadcastSendingErrorMsg(sendingErrorMsg: ""))
    
    let recips : [String] = state.adminNewBroadcastState.recipients.map { String($0) }
    let params : [String : String] = [
        "ShortMsg" : state.adminNewBroadcastState.shortMsg,
        "LongMsg" : state.adminNewBroadcastState.longMsg,
        "Recipients" : recips.joined(separator: ",")
        ]
    let url = UrlMaker.makeUrl(.admin_broadcasts_new) + "/\(state.adminOrgState.adminOrgId)"
    Alamofire.request(url, method: .post, parameters: params).responseJSON {
        response in
        store.dispatch(SetAdminNewBroadcastSending(sending: false))
        if response.result.isSuccess {
            let responseJSON : JSON = JSON(response.result.value!)
            if responseJSON["Success"].bool! {
                var recipients : [String] = []
                if responseJSON["Recipients"].array != nil {
                    for (_, recipient) in responseJSON["Recipients"] {
                        let recip = recipient.string ?? ""
                        if !recip.isEmpty {
                            recipients.append(recipient.string ?? "")
                        }
                    }
                }

                store.dispatch(AddNewBroadcast(
                    broadcastId: responseJSON["BroadcastId"].int ?? 0,
                    shortMsg: responseJSON["ShortMsg"].string ?? "",
                    longMsg: responseJSON["LongMsg"].string ?? "",
                    time: responseJSON["Time"].string ?? "",
                    timestamp: responseJSON["Timestamp"].int ?? 0,
                    isDelivered: responseJSON["IsDelivered"].bool ?? false,
                    usrName: responseJSON["UsrName"].string ?? "",
                    recipients: recipients)
                )
                
                store.dispatch(SetAdminNewBroadcastGoBack(goBack: true))
            } else {
                store.dispatch(SetAdminNewBroadcastSendingErrorMsg(sendingErrorMsg: responseJSON["Error"].string!))
            }
        } else {
            store.dispatch(SetAdminNewBroadcastSendingErrorMsg(sendingErrorMsg: "Unable to send broadcast"))
        }
        
        store.dispatch(SetAdminNewBroadcastGoBack(goBack: true))
    }
 
    return nil
}
