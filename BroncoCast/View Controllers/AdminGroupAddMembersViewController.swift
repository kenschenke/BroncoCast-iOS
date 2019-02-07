//
//  AdminGroupAddMembersViewController.swift
//  BroncoCast
//
//  Created by Ken Schenke on 2/5/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import UIKit
import ReSwift
import Alertift

class AdminGroupAddMembersViewController: UIViewController, StoreSubscriber {

    var fetching = false
    var fetchingErrorMsg = ""
    var nonMembers : [NonMember] = []
    var adding = false
    var addingErrorMsg = ""
    var addingUserId = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        store.subscribe(self)
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    func newState(state: AppState) {
        if nonMembers != state.adminGroupDetailState.nonMembers {
            nonMembers = state.adminGroupDetailState.nonMembers
            tableView.reloadData()
        }
        
        if fetching != state.adminGroupDetailState.fetchingNonMembers {
            fetching = state.adminGroupDetailState.fetchingNonMembers
            tableView.reloadData()
        }
        
        if fetchingErrorMsg != state.adminGroupDetailState.fetchingNonMembersErrorMsg {
            fetchingErrorMsg = state.adminGroupDetailState.fetchingNonMembersErrorMsg
            tableView.reloadData()
        }
        
        if adding != state.adminGroupDetailState.adding {
            adding = state.adminGroupDetailState.adding
            tableView.reloadData()
        }
        
        if addingErrorMsg != state.adminGroupDetailState.addingErrorMsg {
            addingErrorMsg = state.adminGroupDetailState.addingErrorMsg
            if !addingErrorMsg.isEmpty {
                Alertift.alert(title: "An Error Occurred", message: addingErrorMsg)
                    .action(.default("Ok"))
                    .show()
            }
        }
        
        if addingUserId != state.adminGroupDetailState.addingUserId {
            addingUserId = state.adminGroupDetailState.addingUserId
            tableView.reloadData()
        }
    }

}

extension AdminGroupAddMembersViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    // Sections:
    //    0 - users
    //    1 - fetching message
    //    2 - empty table
    //    3 - error message
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return nonMembers.count
        } else if section == 1 && fetching {
            return 1
        } else if section == 2 && nonMembers.isEmpty && !fetching && fetchingErrorMsg.isEmpty {
            return 1
        } else if section == 3 && !fetchingErrorMsg.isEmpty {
            return 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AdminGroupAddMembersDetailCell",
                                                     for: indexPath) as! AdminGroupAddMembersDetailTableViewCell
            
            cell.userNameLabel.text =
                addingUserId == nonMembers[indexPath.row].UserId ? "Adding User" : nonMembers[indexPath.row].UserName
            cell.userId = nonMembers[indexPath.row].UserId
            cell.addButton.isEnabled = !adding
            return cell
        } else if indexPath.section == 1 {
            return tableView.dequeueReusableCell(withIdentifier: "AdminGroupAddMembersFetchingCell", for: indexPath)
        } else if indexPath.section == 2 {
            return tableView.dequeueReusableCell(withIdentifier: "AdminGroupAddMembersEmptyCell", for: indexPath)
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AdminGroupAddMembersErrorMsgCell", for: indexPath) as! AdminGroupAddMembersErrorMsgTableViewCell
            cell.errorMsgLabel.text = fetchingErrorMsg
            return cell
        }
        
        return tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
    }

}
