//
//  AdminGroupsActions.swift
//  BroncoCast
//
//  Created by Ken Schenke on 2/3/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift
import Alamofire
import SwiftyJSON

struct SetAdminGroups : Action {
    var groups : [Group]
}

struct SetAdminGroupsFetching : Action {
    var fetching : Bool
}

struct SetAdminGroupsFetchingErrorMsg : Action {
    var fetchingErrorMsg : String
}

struct AddNewGroup : Action {
    var groupId : Int
    var groupName : String
}

struct RenameGroup : Action {
    var groupId : Int
    var groupName : String
}

struct DeleteGroup : Action {
    var groupId : Int
}

func getAdminGroups(state : AppState, store : Store<AppState>) -> Action? {
    store.dispatch(SetAdminGroupsFetching(fetching: true))
    store.dispatch(SetAdminGroupsFetchingErrorMsg(fetchingErrorMsg: ""))

    let url = UrlMaker.makeUrl(.admin_groups) + "/\(state.adminOrgState.adminOrgId)"
    Alamofire.request(url, method: .get).responseJSON {
        response in
        store.dispatch(SetAdminGroupsFetching(fetching: false))
        if response.result.isSuccess {
            let responseJSON : JSON = JSON(response.result.value!)
            
            if responseJSON["Success"].bool ?? false {
                if responseJSON["Groups"].array != nil {
                    var groups : [Group] = []
                    
                    for (_, user) in responseJSON["Groups"] {
                        groups.append(Group(
                            GroupId: user["GroupId"].int ?? 0,
                            GroupName: user["GroupName"].string ?? ""
                        ))
                    }
                    
                    store.dispatch(SetAdminGroups(groups: groups))
                }
            } else {
                store.dispatch(SetAdminGroupsFetchingErrorMsg(fetchingErrorMsg: responseJSON["Error"].string ?? ""))
            }
        } else {
            store.dispatch(SetAdminGroupsFetchingErrorMsg(fetchingErrorMsg: "Unable to retrieve groups"))
        }
    }
 
    return nil
}

func adminGroupSaveName(state : AppState, store : Store<AppState>) -> Action? {
    if state.adminGroupNameState.groupId != 0 {
        store.dispatch(adminGroupRenameGroup)
    } else {
        store.dispatch(adminGroupAddGroup)
    }
    
    return nil
}

func adminGroupAddGroup(state : AppState, store : Store<AppState>) -> Action? {
    store.dispatch(SetAdminGroupNameSaving(saving: false))
    store.dispatch(SetAdminGroupNameSavingErrorMsg(errorMsg: ""))
    
    let groupName = state.adminGroupNameState.groupName
    let url = UrlMaker.makeUrl(.admin_groups) + "/\(state.adminOrgState.adminOrgId)"
    let params : [String : String] = [
        "Name" : groupName,
        ]
    Alamofire.request(url, method: .post, parameters: params).responseJSON {
        response in
        store.dispatch(SetAdminGroupNameSaving(saving: false))
        if response.result.isSuccess {
            let responseJSON : JSON = JSON(response.result.value!)
            
            if responseJSON["Success"].bool ?? false {
                let groupId = responseJSON["GroupId"].int ?? 0
                store.dispatch(AddNewGroup(groupId: groupId, groupName: groupName))
                store.dispatch(SetAdminGroupNameGoBack(goBack: true))
            } else {
                store.dispatch(SetAdminGroupNameSavingErrorMsg(errorMsg: responseJSON["Error"].string ?? ""))
            }
        } else {
            store.dispatch(SetAdminGroupNameSavingErrorMsg(errorMsg: "Unable to add grouo"))
        }
    }
 
    return nil
}

func adminGroupRenameGroup(state : AppState, store : Store<AppState>) -> Action? {
    store.dispatch(SetAdminGroupNameSaving(saving: false))
    store.dispatch(SetAdminGroupNameSavingErrorMsg(errorMsg: ""))
    
    let groupName = state.adminGroupNameState.groupName
    let groupId = state.adminGroupDetailState.groupId
    let url = UrlMaker.makeUrl(.admin_groups_rename) + "/\(groupId)"
    let params : [String : String] = [
        "Name" : groupName,
        ]
    Alamofire.request(url, method: .post, parameters: params).responseJSON {
        response in
        store.dispatch(SetAdminGroupNameSaving(saving: false))
        if response.result.isSuccess {
            let responseJSON : JSON = JSON(response.result.value!)
            
            if responseJSON["Success"].bool ?? false {
                store.dispatch(RenameGroup(groupId: groupId, groupName: groupName))
                store.dispatch(SetAdminGroupNameGoBack(goBack: true))
            } else {
                store.dispatch(SetAdminGroupNameSavingErrorMsg(errorMsg: responseJSON["Error"].string ?? ""))
            }
        } else {
            store.dispatch(SetAdminGroupNameSavingErrorMsg(errorMsg: "Unable to rename grouo"))
        }
    }
    
    return nil
}
