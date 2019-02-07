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

struct SetAdminGroupDetailNonMembers : Action {
    var nonMembers : [NonMember]
}

struct SetAdminGroupDetailFetchingNonMembers : Action {
    var fetching : Bool
}

struct SetAdminGroupDetailFetchingNonMembersErrorMsg : Action {
    var fetchingErrorMsg : String
}

struct SetAdminGroupDetailAdding : Action {
    var adding : Bool
}

struct SetAdminGroupDetailAddingErrorMsg : Action {
    var addingErrorMsg : String
}

struct SetAdminGroupDetailAddingUserId : Action {
    var addingUserId : Int
}

struct AddGroupMember : Action {
    var userId : Int
    var memberId : Int
    var userName : String
}

struct SetAdminGroupDetailRemoving : Action {
    var removing : Bool
}

struct SetAdminGroupDetailRemovingErrorMsg : Action {
    var removingErrorMsg : String
}

struct SetAdminGroupDetailRemovingMemberId : Action {
    var removingMemberId : Int
}

struct RemoveGroupMember : Action {
    var memberId : Int
    var userId : Int
    var userName : String
}

func addGroupMember(state : AppState, store : Store<AppState>) -> Action? {
    store.dispatch(SetAdminGroupDetailAdding(adding: true))
    store.dispatch(SetAdminGroupDetailAddingErrorMsg(addingErrorMsg: ""))
    
    let users = state.adminGroupDetailState.nonMembers.filter {
        $0.UserId == state.adminGroupDetailState.addingUserId
    }
    if users.count != 1 {
        return nil
    }
    
    let url = UrlMaker.makeUrl(.admin_group_members) + "/\(state.adminGroupDetailState.groupId)"
    let params : [String : String] = [
        "UserId" : String(state.adminGroupDetailState.addingUserId),
        ]
    Alamofire.request(url, method: .post, parameters: params).responseJSON {
        response in
        store.dispatch(SetAdminGroupDetailAdding(adding: false))
        if response.result.isSuccess {
            let responseJSON : JSON = JSON(response.result.value!)
            
            if responseJSON["Success"].bool ?? false {
                let memberId = responseJSON["MemberId"].int ?? 0
                store.dispatch(AddGroupMember(
                    userId: state.adminGroupDetailState.addingUserId,
                    memberId: memberId,
                    userName: users[0].UserName)
                )
                store.dispatch(SetAdminGroupDetailAddingUserId(addingUserId: 0))
            } else {
                store.dispatch(SetAdminGroupDetailAddingErrorMsg(addingErrorMsg: responseJSON["Error"].string ?? ""))
            }
        } else {
            store.dispatch(SetAdminGroupDetailAddingErrorMsg(addingErrorMsg: "Unable to add group member"))
        }
    }

    return nil
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

func getAdminGroupNonMembers(state : AppState, store : Store<AppState>) -> Action? {
    store.dispatch(SetAdminGroupDetailFetchingNonMembers(fetching: true))
    store.dispatch(SetAdminGroupDetailFetchingNonMembersErrorMsg(fetchingErrorMsg: ""))
    store.dispatch(SetAdminGroupDetailNonMembers(nonMembers: []))
    
    let url = UrlMaker.makeUrl(.admin_group_nonmembers) + "/\(state.adminGroupDetailState.groupId)"
    Alamofire.request(url, method: .get).responseJSON {
        response in
        store.dispatch(SetAdminGroupDetailFetchingNonMembers(fetching: false))
        if response.result.isSuccess {
            let responseJSON : JSON = JSON(response.result.value!)
            
            if responseJSON["Success"].bool ?? false {
                if responseJSON["NonMembers"].array != nil {
                    var nonMembers : [NonMember] = []
                    
                    for (_, user) in responseJSON["NonMembers"] {
                        nonMembers.append(NonMember(
                            UserId: user["UserId"].int ?? 0,
                            UserName: user["UserName"].string ?? ""
                        ))
                    }
                    
                    nonMembers.sort(by: { $0.UserName < $1.UserName })
                    store.dispatch(SetAdminGroupDetailNonMembers(nonMembers: nonMembers))
                }
            } else {
                store.dispatch(SetAdminGroupDetailFetchingNonMembersErrorMsg(fetchingErrorMsg: responseJSON["Error"].string ?? ""))
            }
        } else {
            store.dispatch(SetAdminGroupDetailFetchingNonMembersErrorMsg(fetchingErrorMsg: "Unable to retrieve users"))
        }
    }
 
    return nil
}

func removeGroupMember(state : AppState, store : Store<AppState>) -> Action? {
    store.dispatch(SetAdminGroupDetailRemoving(removing: true))
    store.dispatch(SetAdminGroupDetailRemovingErrorMsg(removingErrorMsg: ""))
    
    let users = state.adminGroupDetailState.members.filter {
        $0.MemberId == state.adminGroupDetailState.removingMemberId
    }
    if users.count != 1 {
        return nil
    }
    
    let url = UrlMaker.makeUrl(.admin_group_members) + "/\(state.adminGroupDetailState.removingMemberId)"
    Alamofire.request(url, method: .delete).responseJSON {
        response in
        store.dispatch(SetAdminGroupDetailRemoving(removing: false))
        if response.result.isSuccess {
            let responseJSON : JSON = JSON(response.result.value!)
            
            if responseJSON["Success"].bool ?? false {
                store.dispatch(RemoveGroupMember(
                    memberId: state.adminGroupDetailState.removingMemberId,
                    userId: state.adminGroupDetailState.addingUserId,
                    userName: users[0].MemberName)
                )
                store.dispatch(SetAdminGroupDetailRemovingMemberId(removingMemberId: 0))
            } else {
                store.dispatch(SetAdminGroupDetailRemovingErrorMsg(removingErrorMsg: responseJSON["Error"].string ?? ""))
            }
        } else {
            store.dispatch(SetAdminGroupDetailRemovingErrorMsg(removingErrorMsg: "Unable to remove group member"))
        }
    }
    
    return nil
}

