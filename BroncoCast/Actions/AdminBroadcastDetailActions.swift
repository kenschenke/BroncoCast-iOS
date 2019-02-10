//
//  AdminBroadcastDetailActions.swift
//  BroncoCast
//
//  Created by Ken Schenke on 2/8/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift
import Alamofire
import SwiftyJSON

struct SetAdminBroadcastDetails : Action {
    var broadcastId : Int
    var sentBy : String
    var time : String
    var timestamp : Int
    var isDelivered : Bool
    var isCancelled : Bool
    var shortMsg : String
    var longMsg : String
    var recipients : [String]
}

struct SetAdminBroadcastCancelling : Action {
    var cancelling : Bool
}

struct SetAdminBroadcastCancellingErrorMsg : Action {
    var cancellingErrorMsg : String
}

struct SetAdminBroadcastIsCancelled : Action {
    var isCancelled : Bool
}

struct SetBroadcastCancelled : Action {
    var broadcastId : Int
}

func cancelBroadcast(state : AppState, store : Store<AppState>) -> Action? {
    store.dispatch(SetAdminBroadcastCancelling(cancelling: true))
    store.dispatch(SetAdminBroadcastCancellingErrorMsg(cancellingErrorMsg: ""))
    
    let url = UrlMaker.makeUrl(.admin_broadcasts_cancel) + "/\(state.adminBroadcastDetailState.broadcastId)"
    print("url = \(url)")
    Alamofire.request(url, method: .post).responseJSON {
        response in
        store.dispatch(SetAdminBroadcastCancelling(cancelling: true))
        if response.result.isSuccess {
            let responseJSON : JSON = JSON(response.result.value!)
            
            if responseJSON["Success"].bool ?? false {
                store.dispatch(SetBroadcastCancelled(broadcastId: state.adminBroadcastDetailState.broadcastId))
                store.dispatch(SetAdminBroadcastIsCancelled(isCancelled: true))
            } else {
                store.dispatch(SetAdminBroadcastCancellingErrorMsg(cancellingErrorMsg: responseJSON["Error"].string ?? ""))
            }
        } else {
            store.dispatch(SetAdminBroadcastCancellingErrorMsg(cancellingErrorMsg: "Unable to cancel broadcast"))
        }
    }
 
    return nil
}
