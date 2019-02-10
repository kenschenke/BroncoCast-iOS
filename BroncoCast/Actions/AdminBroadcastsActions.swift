//
//  AdminBroadcastsActions.swift
//  BroncoCast
//
//  Created by Ken Schenke on 2/7/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift
import Alamofire
import SwiftyJSON

struct SetAdminBroadcasts : Action {
    var broadcasts : [AdminBroadcast]
}

struct SetAdminBroadcastsFetching : Action {
    var fetching : Bool
}

struct SetAdminBroadcastsFetchingErrorMsg : Action {
    var fetchingErrorMsg : String
}

func getAdminBroadcasts(state : AppState, store : Store<AppState>) -> Action? {
    store.dispatch(SetAdminBroadcasts(broadcasts: []))
    store.dispatch(SetAdminBroadcastsFetching(fetching: true))
    store.dispatch(SetAdminBroadcastsFetchingErrorMsg(fetchingErrorMsg: ""))
    
    let url = UrlMaker.makeUrl(.admin_broadcasts) + "/\(state.adminOrgState.adminOrgId)"
    Alamofire.request(url, method: .get).responseJSON {
        response in
        store.dispatch(SetAdminBroadcastsFetching(fetching: false))
        if response.result.isSuccess {
            let responseJSON : JSON = JSON(response.result.value!)
            
            if responseJSON["Success"].bool ?? false {
                if responseJSON["Broadcasts"].array != nil {
                    var broadcasts : [AdminBroadcast] = []
                    
                    for (_, broadcast) in responseJSON["Broadcasts"] {
                        var recipients : [String] = []
                        if broadcast["Recipients"].array != nil {
                            for (_, recipient) in broadcast["Recipients"] {
                                let recip = recipient.string ?? ""
                                if !recip.isEmpty {
                                    recipients.append(recipient.string ?? "")
                                }
                            }
                        }
                        
                        broadcasts.append(AdminBroadcast(
                            BroadcastId: broadcast["BroadcastId"].int ?? 0,
                            SentBy: broadcast["UsrName"].string ?? "",
                            Time: broadcast["Time"].string ?? "",
                            Timestamp: broadcast["Timestamp"].int ?? 0,
                            IsDelivered: broadcast["IsDelivered"].bool ?? false,
                            IsCancelled: broadcast["IsCancelled"].bool ?? false,
                            ShortMsg: broadcast["ShortMsg"].string ?? "",
                            LongMsg: broadcast["LongMsg"].string ?? "",
                            Recipients: recipients
                        ))
                    }
                    
                    broadcasts.sort(by: { $0.Timestamp >= $1.Timestamp })
                    
                    store.dispatch(SetAdminBroadcasts(broadcasts: broadcasts))
                }
            } else {
                store.dispatch(SetAdminBroadcastsFetchingErrorMsg(fetchingErrorMsg: responseJSON["Error"].string ?? ""))
            }
        } else {
            store.dispatch(SetAdminBroadcastsFetchingErrorMsg(fetchingErrorMsg: "Unable to retrieve broadcasts"))
        }
    }
 
    return nil
}
