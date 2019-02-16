//
//  AdminUsersActions.swift
//  BroncoCast
//
//  Created by Ken Schenke on 1/27/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift
import Alamofire
import SwiftyJSON

struct SetAdminUsers : Action {
    var users : [AdminUser]
}

struct SetAdminUsersFetching : Action {
    var fetching : Bool
}

struct SetAdminUsersFetchingErrorMsg : Action {
    var errorMsg : String
}

struct SetShowHiddenUsers : Action {
    var showHiddenUsers : Bool
}

func getAdminUsers(state : AppState, store : Store<AppState>) -> Action? {
    store.dispatch(SetAdminUsersFetching(fetching: true))
    store.dispatch(SetAdminUsersFetchingErrorMsg(errorMsg: ""))
    store.dispatch(SetAdminUsers(users: []))

    let url = UrlMaker.makeUrl(.admin_users) + "/\(state.adminOrgState.adminOrgId)"
    Alamofire.request(url, method: .get).responseJSON {
        response in
        store.dispatch(SetAdminUsersFetching(fetching: false))
        if response.result.isSuccess {
            let responseJSON : JSON = JSON(response.result.value!)
            
            if responseJSON["Success"].bool ?? false {
                if responseJSON["Users"].array != nil {
                    var users : [AdminUser] = []
                    
                    for (_, user) in responseJSON["Users"] {
                        var contacts : [UserContact] = []
                        if user["Contacts"].array != nil {
                            for (_, contact) in user["Contacts"] {
                                contacts.append(UserContact(
                                    ContactId: contact["ContactId"].int ?? 0,
                                    ContactName: contact["Contact"].string ?? ""
                                ))
                            }
                        }
                        
                        var smsLogs : [SmsLog] = []
                        if user["SmsLogs"].array != nil {
                            for (_, log) in user["SmsLogs"] {
                                smsLogs.append(SmsLog(
                                    Code: log["Code"].string ?? "",
                                    Message: log["Message"].string ?? "",
                                    Time: log["Time"].string ?? ""
                                ))
                            }
                        }
                        
                        users.append(AdminUser(
                            UserId: user["UserId"].int ?? 0,
                            UserName: user["UsrName"].string ?? "",
                            MemberId: user["MemberId"].int ?? 0,
                            IsAdmin: user["IsAdmin"].bool ?? false,
                            Approved: user["Approved"].bool ?? false,
                            Hidden: user["Hidden"].bool ?? false,
                            Groups: user["Groups"].string ?? "",
                            Contacts: contacts,
                            SmsLogs: smsLogs,
                            HasDeliveryError: user["HasDeliveryError"].bool ?? false
                        ))
                    }
                    
                    store.dispatch(SetAdminUsers(users: users))
                }
            } else {
                store.dispatch(SetAdminUsersFetchingErrorMsg(errorMsg: responseJSON["Error"].string ?? ""))
            }
        } else {
            store.dispatch(SetAdminUsersFetchingErrorMsg(errorMsg: "Unable to organization list"))
        }
    }
 
    return nil
}
