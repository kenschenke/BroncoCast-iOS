//
//  AdminNewBroadcastViewController.swift
//  BroncoCast
//
//  Created by Ken Schenke on 2/8/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import UIKit
import ReSwift
import Alertift

class AdminNewBroadcastViewController: UIViewController, StoreSubscriber {
    
    var goBack = false
    var shortMsg = ""
    var longMsg = ""
    var groupMembers : [String : [BroadcastGroupMember]] = [:]
    var groupKeys : [String] = []
    var recipients : [Int] = []
    var sending = false
    var sendingErrorMsg = ""
    var fetchingGroups = false
    var fetchingGroupsErrorMsg = ""

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendButton: ActivityButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.subscribe(self)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        sendButton.activityLabel = "Sending"
    }
    
    func newState(state: AppState) {
        if shortMsg != state.adminNewBroadcastState.shortMsg {
            shortMsg = state.adminNewBroadcastState.shortMsg
            tableView.reloadData()
        }
        
        if longMsg != state.adminNewBroadcastState.longMsg {
            longMsg = state.adminNewBroadcastState.longMsg
            tableView.reloadData()
        }
        
        if recipients != state.adminNewBroadcastState.recipients {
            recipients = state.adminNewBroadcastState.recipients
            tableView.reloadData()
        }
        
        if groupMembers != state.adminNewBroadcastState.groupMembers {
            groupMembers = state.adminNewBroadcastState.groupMembers
            groupKeys = []
            for (group, _) in groupMembers {
                groupKeys.append(group)
            }
            groupKeys.sort()
            tableView.reloadData()
        }
        
        if sending != state.adminNewBroadcastState.sending {
            sending = state.adminNewBroadcastState.sending
            if sending {
                sendButton.showActivity()
            } else {
                sendButton.hideActivity()
            }
        }
        
        if sendingErrorMsg != state.adminNewBroadcastState.sendingErrorMsg {
            sendingErrorMsg = state.adminNewBroadcastState.sendingErrorMsg
            if !sendingErrorMsg.isEmpty {
                Alertift.alert(title: "An Error Occurred", message: sendingErrorMsg)
                    .action(.default("Ok"))
                    .show()
            }
        }
        
        if fetchingGroups != state.adminNewBroadcastState.fetchingGroups {
            fetchingGroups = state.adminNewBroadcastState.fetchingGroups
            tableView.reloadData()
        }
        
        if fetchingGroupsErrorMsg != state.adminNewBroadcastState.fetchingGroupsErrorMsg {
            fetchingGroupsErrorMsg = state.adminNewBroadcastState.fetchingGroupsErrorMsg
            if !fetchingGroupsErrorMsg.isEmpty {
                Alertift.alert(title: "An Error Occurred", message: fetchingGroupsErrorMsg)
                    .action(.default("Ok"))
                    .show()
            }
        }
        
        if goBack != state.adminNewBroadcastState.goBack {
            goBack = state.adminNewBroadcastState.goBack
            if goBack {
                _ = navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        if shortMsg.trimmingCharacters(in: .whitespaces).isEmpty {
            Alertift.alert(title: "An Error Occurred", message: "A short message is required")
                .action(.default("Ok"))
                .show()
            return
        }
        
        if recipients.isEmpty {
            Alertift.alert(title: "An Error Occurred", message: "At least one recipient is required")
                .action(.default("Ok"))
                .show()
            return
        }
        
        store.dispatch(sendBroadcast)
    }
}

extension AdminNewBroadcastViewController: UITableViewDelegate, UITableViewDataSource {
    
    // 0 - short message
    // 1 - long message
    // 2 - groups (recipients)
    // 3 - fetching message
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return fetchingGroups ? 0 : 1
        } else if section == 2 {
            return groupMembers.count
        } else if section == 3 && fetchingGroups {
            return 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AdminNewBroadcastMsgCell", for: indexPath) as! AdminNewBroadcastMsgTableViewCell
            cell.titleLabel.text = "Short Message"
            cell.msgLabel.text = shortMsg.isEmpty ? "Tap to set the short message" : shortMsg
            
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AdminNewBroadcastMsgCell", for: indexPath) as! AdminNewBroadcastMsgTableViewCell
            cell.titleLabel.text = "Long Message"
            cell.msgLabel.text = longMsg.isEmpty ? "Tap to set the long message" : longMsg
            
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AdminNewBroadcastGroupCell", for: indexPath) as! AdminNewBroadcastGroupTableViewCell
            
            let group = groupKeys[indexPath.row]
            cell.groupLabel.text = group
            
            let recips = numberOfRecipients(inGroup: group)
            var summary = ""
            if recips == 0 {
                summary = "No recipients selected"
            } else if isEveryoneSelected(inGroup: group) {
                summary = "All group members selected"
            } else {
                let numMembers = numberOfMembers(inGroup: group)
                let suffix = numMembers == 1 ? "" : "s"
                summary = "\(recips) out of \(numMembers) member\(suffix) selected"
            }
            cell.recipientsSummaryLabel.text = summary

            return cell
        } else if indexPath.section == 3 {
            return tableView.dequeueReusableCell(withIdentifier: "AdminNewBroadcastFetchingCell", for: indexPath)
        }
        
        return tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if !fetchingGroups && section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AdminNewBroadcastRecipientsHeader") as! AdminBroadcastRecipientsHeaderTableViewCell
            
            var summary = ""
            if recipients.isEmpty {
                summary = "No recipients selected"
            } else {
                let suffix = recipients.count == 1 ? "" : "s"
                summary = "\(recipients.count) recipient\(suffix) selected"
            }
            cell.recipientCountLabel.text = summary
            
            return cell.contentView
        }
        
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if !fetchingGroups && section == 2 {
            return 32
        }
        
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            // short message
            store.dispatch(SetAdminNewBroadcastEditingMsg(editingMsg: .shortMsg))
            performSegue(withIdentifier: "showAdminNewBroadcastMsg", sender: self)
        } else if indexPath.section == 1 {
            // long message
            store.dispatch(SetAdminNewBroadcastEditingMsg(editingMsg: .longMsg))
            performSegue(withIdentifier: "showAdminNewBroadcastMsg", sender: self)
        } else if indexPath.section == 2 {
            // groups
            store.dispatch(SetAdminNewBroadcastSelectedGroup(selectedGroup: groupKeys[indexPath.row]))
            performSegue(withIdentifier: "showAdminNewBroadcastGroupMembers", sender: self)
        }
    }
    
}

// Code to manage recipient list
extension AdminNewBroadcastViewController {
    
    func isEveryoneSelected(inGroup group : String) -> Bool {
        var areAllSelected = false
        
        if let members = groupMembers[group] {
            areAllSelected = true
            for member in members {
                if !recipients.contains(member.UserId) {
                    areAllSelected = false
                    break
                }
            }
        }
        
        return areAllSelected
    }
    
    func numberOfMembers(inGroup group : String) -> Int {
        if let members = groupMembers[group] {
            return members.count
        }
        
        return 0
    }
    
    func numberOfRecipients(inGroup group : String) -> Int {
        var count = 0
        
        if let members = groupMembers[group] {
            for member in members {
                if recipients.contains(member.UserId) {
                    count += 1
                }
            }
        }

        return count
    }
    
}
