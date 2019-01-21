//
//  ProfileContactsActions.swift
//  BroncoCast
//
//  Created by Ken Schenke on 1/19/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift
import Alamofire
import SwiftyJSON

struct SetProfileContactsFetching : Action {
    var fetching : Bool
}

struct SetProfileContactsErrorMsg : Action {
    var errorMsg : String
}

struct SetProfileContactsContacts : Action {
    var contacts : [Contact]
}

struct SetProfileContactsNavBack : Action {
    var goBack : Bool
}

struct SetProfileContactToEdit : Action {
    var contactId : Int
    var contactName : String
}

struct SetProfileContactSaving : Action {
    var saving : Bool
}

struct SetProfileContactEditErrorMsg : Action {
    var errorMsg : String
}

struct AddProfileContact : Action {
    var contactId : Int
    var contactName : String
}

struct UpdateProfileContact : Action {
    var contactId : Int
    var contactName : String
}

struct DeleteProfileContact : Action {
    var contactId : Int
}

struct SetProfileContactDeleting : Action {
    var deleting : Bool
}

struct SetProfileContactTesting : Action {
    var testing : Bool
}

struct SetProfileContactTestSent : Action {
    var testSent : Bool
}

func getProfileContacts(state : AppState, store : Store<AppState>) -> Action? {
    store.dispatch(SetProfileContactsErrorMsg(errorMsg: ""))
    store.dispatch(SetProfileContactsFetching(fetching: true))
    
    Alamofire.request(UrlMaker.makeUrl(.profile_contacts), method: .get).responseJSON {
        response in
        store.dispatch(SetProfileContactsFetching(fetching: false))
        if response.result.isSuccess {
            //            print(response.result.value)
            let responseJSON : JSON = JSON(response.result.value!)
            
            if responseJSON["Success"].bool ?? false {
                if responseJSON["Contacts"].array != nil {
                    var contacts : [Contact] = []
                    
                    for (_, object) in responseJSON["Contacts"] {
                        contacts.append(Contact(
                            contactId: object["ContactId"].int ?? 0,
                            contact: object["Contact"].string ?? ""
                        ))
                    }
                    
                    store.dispatch(SetProfileContactsContacts(contacts: contacts))
                }
            } else {
                store.dispatch(SetProfileContactsErrorMsg(errorMsg: responseJSON["Error"].string ?? ""))
            }
        } else {
            store.dispatch(SetProfileContactsErrorMsg(errorMsg: "Unable to retrieve profile information"))
        }
    }
 
    return nil
}

func saveProfileContact(state :AppState, store :Store<AppState>) -> Action? {
    store.dispatch(SetProfileContactSaving(saving: true))
    store.dispatch(SetProfileContactEditErrorMsg(errorMsg: ""))
    
    let params : [String : String] = [
        "Key" : state.profileContactsEditState.contactName,
    ]
    var url = UrlMaker.makeUrl(.profile_contacts)
    if state.profileContactsEditState.contactId != 0 {
        url += "/\(state.profileContactsEditState.contactId)"
    }
    Alamofire.request(url, method: .post, parameters: params).responseJSON {
        response in
        store.dispatch(SetProfileContactSaving(saving: false))
        if response.result.isSuccess {
            let responseJSON : JSON = JSON(response.result.value!)
            if responseJSON["Success"].bool! {
                if state.profileContactsEditState.contactId != 0 {
                    store.dispatch(UpdateProfileContact(contactId: state.profileContactsEditState.contactId,
                                                        contactName: state.profileContactsEditState.contactName))
                } else {
                    store.dispatch(AddProfileContact(contactId: responseJSON["ContactId"].int!,
                                                     contactName: state.profileContactsEditState.contactName))
                }
            } else {
                store.dispatch(SetProfileContactEditErrorMsg(errorMsg: responseJSON["Error"].string!))
            }
        } else {
            store.dispatch(SetProfileContactEditErrorMsg(errorMsg: "Unable to save contact record"))
        }
        
        store.dispatch(SetProfileContactsNavBack(goBack: true))
    }

    return nil
}

func deleteProfileContact(state :AppState, store :Store<AppState>) -> Action? {
    store.dispatch(SetProfileContactEditErrorMsg(errorMsg: ""))
    store.dispatch(SetProfileContactDeleting(deleting: true))

    let url = UrlMaker.makeUrl(.profile_contacts) + "/\(state.profileContactsEditState.contactId)"
    Alamofire.request(url, method: .delete).responseJSON {
        response in
        store.dispatch(SetProfileContactDeleting(deleting: false))
        if response.result.isSuccess {
            let responseJSON : JSON = JSON(response.result.value!)
            if responseJSON["Success"].bool! {
                store.dispatch(DeleteProfileContact(contactId: state.profileContactsEditState.contactId))
                store.dispatch(SetProfileContactsNavBack(goBack: true))
            } else {
                store.dispatch(SetProfileContactEditErrorMsg(errorMsg: responseJSON["Error"].string!))
            }
        } else {
            store.dispatch(SetProfileContactEditErrorMsg(errorMsg: "Unable to delete contact record"))
        }
        
        store.dispatch(SetProfileContactsNavBack(goBack: true))
    }

    return nil
}

func testProfileContact(state :AppState, store :Store<AppState>) -> Action? {
    store.dispatch(SetProfileContactEditErrorMsg(errorMsg: ""))
    store.dispatch(SetProfileContactTesting(testing: true))
    
    let url = UrlMaker.makeUrl(.profile_contacts) + "/test/\(state.profileContactsEditState.contactId)"
    Alamofire.request(url, method: .put).responseJSON {
        response in
        store.dispatch(SetProfileContactTesting(testing: false))
        if response.result.isSuccess {
            let responseJSON : JSON = JSON(response.result.value!)
            if responseJSON["Success"].bool! {
                store.dispatch(SetProfileContactTestSent(testSent: true))
            } else {
                store.dispatch(SetProfileContactEditErrorMsg(errorMsg: responseJSON["Error"].string!))
            }
        } else {
            store.dispatch(SetProfileContactEditErrorMsg(errorMsg: "Unable to send test message"))
        }
    }
 
    return nil
}
