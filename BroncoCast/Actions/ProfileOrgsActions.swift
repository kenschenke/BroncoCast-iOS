//
//  ProfileOrgsActions.swift
//  BroncoCast
//
//  Created by Ken Schenke on 12/30/18.
//  Copyright © 2018 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift
import Alamofire
import SwiftyJSON

struct SetAdminOrgs : Action {
    var adminOrgs : [AdminOrg]
    var notAdmin : Bool
}

struct SetUserOrgs : Action {
    var userOrgs : [UserOrg]
}

struct SetUserOrgsFetching : Action {
    var fetching : Bool
}

struct SetUserOrgsErrorMsg : Action {
    var errorMsg : String
}

struct DropUserOrg : Action {
    var memberId : Int
}

struct SetJoinTag : Action {
    var joinTag : String
}

struct SetUserOrgsJoining : Action {
    var joining : Bool
}

struct SetUserOrgsJoiningErrorMsg : Action {
    var joiningErrorMsg : String
}

struct SetDropMemberId : Action {
    var memberId : Int
}

struct SetDropping : Action {
    var dropping : Bool
}

struct SetDroppingErrorMsg : Action {
    var droppingErrorMsg : String
}

struct AddUserOrg : Action {
    var OrgId : Int
    var OrgName : String
    var MemberId : Int
    var IsAdmin : Bool
}

func dropUserOrg(state : AppState, store : Store<AppState>) -> Action? {
    store.dispatch(SetDropping(dropping: true))
    store.dispatch(SetDroppingErrorMsg(droppingErrorMsg: ""))
    
    let url = UrlMaker.makeUrl(.user_orgs) + "/\(state.profileOrgsState.dropMemberId)"
    Alamofire.request(url, method: .delete).responseJSON {
        response in
        store.dispatch(SetDropping(dropping: false))
        if response.result.isSuccess {
            let responseJSON : JSON = JSON(response.result.value!)
            
            if responseJSON["Success"].bool ?? false {
                store.dispatch(DropUserOrg(memberId: state.profileOrgsState.dropMemberId))
                store.dispatch(SetDropMemberId(memberId: 0))
            } else {
                store.dispatch(SetDroppingErrorMsg(droppingErrorMsg: responseJSON["Error"].string ?? ""))
            }
        } else {
            store.dispatch(SetDroppingErrorMsg(droppingErrorMsg: "Unable to drop organization"))
        }
    }
    
    return nil
}

func getUserOrgs(state : AppState, store : Store<AppState>) -> Action? {
    store.dispatch(SetUserOrgsFetching(fetching: true))
    store.dispatch(SetUserOrgsErrorMsg(errorMsg: ""))
    
    Alamofire.request(UrlMaker.makeUrl(.user_orgs), method: .get).responseJSON {
        response in
        store.dispatch(SetUserOrgsFetching(fetching: false))
        if response.result.isSuccess {
            let responseJSON : JSON = JSON(response.result.value!)
            
            if responseJSON["Success"].bool ?? false {
                if responseJSON["Orgs"].array != nil {
                    var orgs : [UserOrg] = []
                    
                    for (_, object) in responseJSON["Orgs"] {
                        orgs.append(UserOrg(
                            OrgId: object["OrgId"].int ?? 0,
                            OrgName: object["OrgName"].string ?? "",
                            IsAdmin: object["IsAdmin"].bool ?? false,
                            MemberId: object["MemberId"].int ?? 0
                        ))
                    }
                    
                    store.dispatch(SetUserOrgs(userOrgs: orgs))
                }
            } else {
                store.dispatch(SetUserOrgsErrorMsg(errorMsg: responseJSON["Error"].string ?? ""))
            }
        } else {
            store.dispatch(SetUserOrgsErrorMsg(errorMsg: "Unable to organization list"))
        }
    }

    return nil
}

func joinOrg(state : AppState, store : Store<AppState>) -> Action? {
    store.dispatch(SetUserOrgsJoining(joining: true))
    store.dispatch(SetUserOrgsJoiningErrorMsg(joiningErrorMsg: ""))
    
    let params : [String : String] = [
        "Tag" : state.profileOrgsState.joinTag
        ]
    Alamofire.request(UrlMaker.makeUrl(.user_orgs), method: .post, parameters: params).responseJSON {
        response in
        store.dispatch(SetUserOrgsJoining(joining: false))
        if response.result.isSuccess {
            let responseJSON : JSON = JSON(response.result.value!)
            
            if responseJSON["Success"].bool ?? false {
                store.dispatch(AddUserOrg(OrgId: responseJSON["OrgId"].int ?? 0,
                                    OrgName: responseJSON["OrgName"].string ?? "",
                                    MemberId: responseJSON["MemberId"].int ?? 0,
                                    IsAdmin: responseJSON["IsSytemAdmin"].bool ?? false))
                store.dispatch(SetJoinTag(joinTag: ""))
            } else {
                store.dispatch(SetUserOrgsJoiningErrorMsg(joiningErrorMsg: responseJSON["Error"].string ?? ""))
            }
        } else {
            store.dispatch(SetUserOrgsJoiningErrorMsg(joiningErrorMsg: "Unable to join organization"))
        }
    }
    
    return nil
}

