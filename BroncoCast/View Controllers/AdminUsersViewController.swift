//
//  AdminUsersViewController.swift
//  BroncoCast
//
//  Created by Ken Schenke on 1/26/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import UIKit
import ReSwift

class AdminUsersViewController: UIViewController, StoreSubscriber {
    
    var users : [AdminUser] = []
    var fetching = false
    var fetchingErrorMsg = ""
    var adminOrgId = 0
    var numUnapprovedUsers = 0
    var numDeliveryProblems = 0
    var showHiddenUsers = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deliveryProblemsLabel: UILabel!
    @IBOutlet weak var unapprovedUsersLabel: UILabel!
    @IBOutlet weak var showHiddenUsersSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        store.subscribe(self)

        deliveryProblemsLabel.text = ""
        unapprovedUsersLabel.text = ""
    }
    
    func newState(state: AppState) {
        if users != state.adminUsersState.filteredUsers {
            users = state.adminUsersState.filteredUsers
            tableView.reloadData()
        }
        
        if fetching != state.adminUsersState.fetching {
            fetching = state.adminUsersState.fetching
            tableView.reloadData()
        }
        
        if fetchingErrorMsg != state.adminUsersState.fetchingErrorMsg {
            fetchingErrorMsg = state.adminUsersState.fetchingErrorMsg
            tableView.reloadData()
        }
        
        if adminOrgId != state.adminOrgState.adminOrgId {
            adminOrgId = state.adminOrgState.adminOrgId
            store.dispatch(getAdminUsers)
        }
        
        if numUnapprovedUsers != state.adminUsersState.numUnapprovedUsers {
            numUnapprovedUsers = state.adminUsersState.numUnapprovedUsers
            if numUnapprovedUsers == 0 {
                unapprovedUsersLabel.text = ""
            } else {
                unapprovedUsersLabel.text =
                    "\(numUnapprovedUsers) unapproved user\(numUnapprovedUsers == 1 ? "" : "s")"
            }
        }
        
        if numDeliveryProblems != state.adminUsersState.numDeliveryProblems {
            numDeliveryProblems = state.adminUsersState.numDeliveryProblems
            if numDeliveryProblems == 0 {
                deliveryProblemsLabel.text = ""
            } else {
                deliveryProblemsLabel.text =
                "\(numDeliveryProblems) delivery problem\(numDeliveryProblems == 1 ? "" : "s")"
            }
        }
        
        if showHiddenUsers != state.adminUsersState.showHiddenUsers {
            showHiddenUsers = state.adminUsersState.showHiddenUsers
            showHiddenUsersSwitch.setOn(showHiddenUsers, animated: true)
        }
        
        if state.navigationState.dataRefreshNeeded &&
            state.navigationState.pathSegment == .admin_users_segment {
            
            store.dispatch(clearDataRefreshNeeded())
            if adminOrgId == state.adminOrgState.adminOrgId {
                store.dispatch(getAdminUsers)
            }
        }
    }
    
    @IBAction func showHiddenUsersSwitchChanged(_ sender: Any) {
        store.dispatch(SetShowHiddenUsers(showHiddenUsers: showHiddenUsersSwitch.isOn))
    }
}

extension AdminUsersViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 80
        }
        
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        store.dispatch(SetAdminUserDetailInit(
            memberId: users[indexPath.row].MemberId,
            userName: users[indexPath.row].UserName,
            isHidden: users[indexPath.row].Hidden,
            isAdmin: users[indexPath.row].IsAdmin,
            isApproved: users[indexPath.row].Approved,
            contacts: users[indexPath.row].Contacts
        ))
        performSegue(withIdentifier: "showAdminUserDetail", sender: self)
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
            return users.count
        } else if section == 1 && fetching {
            return 1
        } else if section == 2 && users.isEmpty && !fetching && fetchingErrorMsg.isEmpty {
            return 1
        } else if section == 3 && !fetchingErrorMsg.isEmpty {
            return 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AdminUsersCell",
                                                     for: indexPath) as! AdminUsersTableViewCell
            cell.userNameLabel.text =
                users[indexPath.row].UserName +
                (users[indexPath.row].IsAdmin ? " (Admin)" : "") +
                (users[indexPath.row].Hidden ? " (Hidden)" : "")
            cell.groupsLabel.text = users[indexPath.row].Groups
            
            if !users[indexPath.row].Approved {
                cell.cellView.borderColor = .orange
                cell.cellView.borderWidth = 3
            } else if users[indexPath.row].HasDeliveryError {
                cell.cellView.borderColor = .red
                cell.cellView.borderWidth = 3
            } else {
                cell.cellView.borderWidth = 0
            }
            
            return cell
        } else if indexPath.section == 1 {
            return tableView.dequeueReusableCell(withIdentifier: "AdminUsersFetchingCell", for: indexPath)
        } else if indexPath.section == 2 {
            return tableView.dequeueReusableCell(withIdentifier: "AdminUsersEmptyCell", for: indexPath)
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AdminUsersErrorMsgCell", for: indexPath) as! AdminUsersErrorMsgTableViewCell
            cell.errorMsgLabel.text = fetchingErrorMsg
            return cell
        }

        return tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
    }
    
}
