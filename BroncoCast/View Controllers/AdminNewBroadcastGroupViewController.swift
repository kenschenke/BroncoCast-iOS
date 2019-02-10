//
//  AdminNewBroadcastGroupViewController.swift
//  BroncoCast
//
//  Created by Ken Schenke on 2/9/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import UIKit
import ReSwift
import FontAwesome_swift

class AdminNewBroadcastGroupViewController: UIViewController, StoreSubscriber {
    
    var goBack = false
    var group = ""
    var groupMembers : [String : [BroadcastGroupMember]] = [:]
    var recipients : [Int] = []

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectedSummaryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.subscribe(self)
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    func newState(state: AppState) {
        if group != state.adminNewBroadcastState.selectedGroup {
            group = state.adminNewBroadcastState.selectedGroup
            tableView.reloadData()
            updateSummary()
        }
        
        if groupMembers != state.adminNewBroadcastState.groupMembers {
            groupMembers = state.adminNewBroadcastState.groupMembers
            tableView.reloadData()
            updateSummary()
        }
        
        if recipients != state.adminNewBroadcastState.recipients {
            recipients = state.adminNewBroadcastState.recipients
            tableView.reloadData()
            updateSummary()
        }
        
        if goBack != state.adminNewBroadcastState.goBack {
            goBack = state.adminNewBroadcastState.goBack
            if goBack {
                _ = navigationController?.popViewController(animated: true)
            }
        }
    }

    @IBAction func selectAllPressed(_ sender: Any) {
        if let members = groupMembers[group] {
            for member in members {
                store.dispatch(AdminNewBroadcastAddRecipient(userId: member.UserId))
            }
        }
    }
    
    @IBAction func clearAllPressed(_ sender: Any) {
        if let members = groupMembers[group] {
            for member in members {
                store.dispatch(AdminNewBroadcastRemoveRecipient(userId: member.UserId))
            }
        }
    }
    
    func updateSummary() {
        if let members = groupMembers[group] {
            var count = 0
            for member in members {
                if recipients.contains(member.UserId) {
                    count += 1
                }
            }
            
            var summary = ""
            if count == 0 {
                summary = "No members selected"
            } else if count == members.count {
                summary = "All members selected"
            } else {
                let suffix = members.count == 1 ? "" : "s"
                summary = "\(count) out of \(members.count) member\(suffix) selected"
            }
            selectedSummaryLabel.text = summary
        }
    }
    
}

extension AdminNewBroadcastGroupViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let members = groupMembers[group] {
            return members.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdminNewBroadcastGroupMemberCell", for: indexPath) as! AdminNewBroadcastGroupMemberTableViewCell
        
        if let members = groupMembers[group] {
            cell.memberNameLabel.text = members[indexPath.row].UserName
            let isSelected = recipients.contains(members[indexPath.row].UserId)
            cell.checkLabel.text = isSelected ? String.fontAwesomeIcon(name: .check) : ""
        } else {
            cell.memberNameLabel.text = ""
            cell.checkLabel.text = ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let members = groupMembers[group] {
            let userId = members[indexPath.row].UserId
            let isSelected = recipients.contains(userId)
            if isSelected {
                store.dispatch(AdminNewBroadcastRemoveRecipient(userId: userId))
            } else {
                store.dispatch(AdminNewBroadcastAddRecipient(userId: userId))
            }
        }
    }
    
}
