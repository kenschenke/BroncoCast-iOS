//
//  AdminGroupRemoveMembersViewController.swift
//  BroncoCast
//
//  Created by Ken Schenke on 2/7/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import UIKit
import ReSwift
import Alertift

class AdminGroupRemoveMembersViewController: UIViewController, StoreSubscriber {
    
    var members : [GroupMember] = []
    var removing = false
    var removingErrorMsg = ""
    var removingMemberId = 0

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        store.subscribe(self)
    }
    
    func newState(state: AppState) {
        if members != state.adminGroupDetailState.members {
            members = state.adminGroupDetailState.members
            tableView.reloadData()
        }
        
        if removing != state.adminGroupDetailState.removing {
            removing = state.adminGroupDetailState.removing
            tableView.reloadData()
        }
        
        if removingErrorMsg != state.adminGroupDetailState.removingErrorMsg {
            removingErrorMsg = state.adminGroupDetailState.removingErrorMsg
            if !removingErrorMsg.isEmpty {
                Alertift.alert(title: "An Error Occurred", message: removingErrorMsg)
                    .action(.default("Ok"))
                    .show()
            }
        }
        
        if removingMemberId != state.adminGroupDetailState.removingMemberId {
            removingMemberId = state.adminGroupDetailState.removingMemberId
            tableView.reloadData()
        }
    }
    
}

extension AdminGroupRemoveMembersViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    // Sections:
    //    0 - members
    //    1 - empty table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return members.count
        } else if section == 1 && members.isEmpty {
            return 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AdminGroupRemoveMembersDetailCell",
                                                     for: indexPath) as! AdminGroupRemoveMembersDetailTableViewCell
            
            cell.memberNameLabel.text =
                removingMemberId == members[indexPath.row].MemberId ? "Removing Member" : members[indexPath.row].MemberName
            cell.memberId = members[indexPath.row].MemberId
            cell.removeButton.isEnabled = !removing
            return cell
        } else if indexPath.section == 1 {
            return tableView.dequeueReusableCell(withIdentifier: "AdminGroupRemoveMembersEmptyCell", for: indexPath)
        }
        
        return tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
    }
    
}
