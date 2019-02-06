//
//  AdminGroupDetailActions.swift
//  BroncoCast
//
//  Created by Ken Schenke on 2/4/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift
import Alamofire
import SwiftyJSON

struct InitAdminGroupDetail : Action {
    var groupId : Int
    var groupName : String
}

struct SetAdminGroupDetailGroupId : Action {
    var groupId : Int
}

struct SetAdminGroupDetailGroupName : Action {
    var groupName : String
}

struct SetAdminGroupDetailMembers : Action {
    var members : [GroupMember]
}

struct SetAdminGroupDetailFetching : Action {
    var fetching : Bool
}

struct SetAdminGroupDetailFetchingErrorMsg : Action {
    var fetchingErrorMsg : String
}

struct SetAdminGroupDetailDeleting : Action {
    var deleting : Bool
}

struct SetAdminGroupDetailDeletingErrorMsg : Action {
    var deletingErrorMsg : String
}

struct SetAdminGroupDetailGoBack : Action {
    var goBack : Bool
}

func adminDeleteGroup(state : AppState, store : Store<AppState>) -> Action? {
    store.dispatch(SetAdminGroupDetailDeleting(deleting: true))
    store.dispatch(SetAdminGroupDetailDeletingErrorMsg(deletingErrorMsg: ""))
    
    let groupId = state.adminGroupDetailState.groupId
    
    let url = UrlMaker.makeUrl(.admin_groups_remove) + "/\(groupId)"
    Alamofire.request(url, method: .delete).responseJSON {
        response in
        store.dispatch(SetAdminGroupDetailDeleting(deleting: false))
        if response.result.isSuccess {
            let responseJSON : JSON = JSON(response.result.value!)
            
            if responseJSON["Success"].bool ?? false {
                store.dispatch(DeleteGroup(groupId: groupId))
                store.dispatch(SetAdminGroupDetailGoBack(goBack: true))
            } else {
                store.dispatch(SetAdminGroupDetailDeletingErrorMsg(deletingErrorMsg: responseJSON["Error"].string ?? ""))
            }
        } else {
            store.dispatch(SetAdminGroupDetailDeletingErrorMsg(deletingErrorMsg: "Unable to delete group"))
        }
    }
 
    return nil
}
func getAdminGroupMembers(state : AppState, store : Store<AppState>) -> Action? {
    store.dispatch(SetAdminGroupDetailFetching(fetching: true))
    store.dispatch(SetAdminGroupDetailFetchingErrorMsg(fetchingErrorMsg: ""))
    
    let url = UrlMaker.makeUrl(.admin_group_members) + "/\(state.adminGroupDetailState.groupId)"
    Alamofire.request(url, method: .get).responseJSON {
        response in
        store.dispatch(SetAdminGroupDetailFetching(fetching: false))
        if response.result.isSuccess {
            let responseJSON : JSON = JSON(response.result.value!)
            
            if responseJSON["Success"].bool ?? false {
                if responseJSON["Members"].array != nil {
                    var members : [GroupMember] = []
                    
                    for (_, user) in responseJSON["Members"] {
                        members.append(GroupMember(
                            MemberId: user["MemberId"].int ?? 0,
                            MemberName: user["UserName"].string ?? ""
                        ))
                    }
                    
                    members.sort(by: { $0.MemberName < $1.MemberName })
                    store.dispatch(SetAdminGroupDetailMembers(members: members))
                }
            } else {
                store.dispatch(SetAdminGroupDetailFetchingErrorMsg(fetchingErrorMsg: responseJSON["Error"].string ?? ""))
            }
        } else {
            store.dispatch(SetAdminGroupDetailFetchingErrorMsg(fetchingErrorMsg: "Unable to retrieve members"))
        }
    }
 
    return nil
}
