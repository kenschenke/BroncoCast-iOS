//
//  UserBroadcastsActions.swift
//  BroncoCast
//
//  Created by Ken Schenke on 1/1/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift
import Alamofire
import SwiftyJSON

struct SetUserBroadcastsFetching : Action {
    var fetching : Bool
}

struct SetUserBroadcastsErrorMsg : Action {
    var errorMsg : String
}

struct SetUserBroadcastsBroadcasts : Action {
    var broadcasts : [Broadcast]
}

func getUserBroadcasts(state : AppState, store : Store<AppState>) -> Action? {
    store.dispatch(SetUserBroadcastsErrorMsg(errorMsg: ""))
    store.dispatch(SetUserBroadcastsFetching(fetching: true))
    store.dispatch(SetUserBroadcastsBroadcasts(broadcasts: []))

    Alamofire.request(UrlMaker.makeUrl(.user_broadcasts), method: .get).responseJSON {
        response in
        store.dispatch(SetUserBroadcastsFetching(fetching: false))
        if response.result.isSuccess {
            let responseJSON : JSON = JSON(response.result.value!)
            
            if responseJSON["Success"].bool ?? false {
                if responseJSON["Broadcasts"].array != nil {
                    var broadcasts : [Broadcast] = []
                    
                    for (_, object) in responseJSON["Broadcasts"] {
                        broadcasts.append(Broadcast(
                            sentBy: object["UsrName"].string ?? "",
                            delivered: object["Delivered"].string ?? "",
                            shortMsg: object["ShortMsg"].string ?? "",
                            longMsg: object["LongMsg"].string ?? "",
                            recipients: [String]()
                        ))
                    }
                    
                    store.dispatch(SetUserBroadcastsBroadcasts(broadcasts: broadcasts))
                }
            } else {
                store.dispatch(SetUserBroadcastsErrorMsg(errorMsg: responseJSON["Error"].string ?? ""))
            }
        } else {
            store.dispatch(SetUserBroadcastsErrorMsg(errorMsg: "Unable to retrieve broadcasts"))
        }
    }
    
    return nil
}

