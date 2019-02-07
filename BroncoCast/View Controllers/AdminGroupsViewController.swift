//
//  AdminGroupsViewController.swift
//  BroncoCast
//
//  Created by Ken Schenke on 2/3/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import UIKit
import ReSwift

class AdminGroupsViewController: UIViewController, StoreSubscriber {

    var adminOrgId = 0
    var groups : [Group] = []
    var fetching = false
    var fetchingErrorMsg = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        store.subscribe(self)
    }
    
    func newState(state: AppState) {
        if groups != state.adminGroupsState.groups {
            groups = state.adminGroupsState.groups
            tableView.reloadData()
        }
        
        if fetching != state.adminGroupsState.fetching {
            fetching = state.adminGroupsState.fetching
            tableView.reloadData()
        }
        
        if fetchingErrorMsg != state.adminGroupsState.fetchingErrorMsg {
            fetchingErrorMsg = state.adminGroupsState.fetchingErrorMsg
            tableView.reloadData()
        }
        
        if adminOrgId != state.adminOrgState.adminOrgId {
            adminOrgId = state.adminOrgState.adminOrgId
            store.dispatch(getAdminGroups)
        }
        
        if state.navigationState.dataRefreshNeeded &&
            state.navigationState.pathSegment == .admin_groups_segment {
            
            store.dispatch(clearDataRefreshNeeded())
            if adminOrgId == state.adminOrgState.adminOrgId {
                store.dispatch(getAdminGroups)
            }
        }
    }
    
    @IBAction func addGroupPressed(_ sender: Any) {
        store.dispatch(SetAdminGroupNameId(groupId: 0))
        store.dispatch(SetAdminGroupName(groupName: ""))
        store.dispatch(SetAdminGroupNameSaving(saving: false))
        store.dispatch(SetAdminGroupNameSavingErrorMsg(errorMsg: ""))
        store.dispatch(SetAdminGroupNameGoBack(goBack: false))
        
        performSegue(withIdentifier: "showAddGroupName", sender: self)
    }
    
}

extension AdminGroupsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 64
        }
        
        return 44
    }

    // Sections:
    //    0 - groups
    //    1 - fetching message
    //    2 - empty table
    //    3 - error message
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return groups.count
        } else if section == 1 && fetching {
            return 1
        } else if section == 2 && groups.isEmpty && !fetching && fetchingErrorMsg.isEmpty {
            return 1
        } else if section == 3 && !fetchingErrorMsg.isEmpty {
            return 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AdminGroupsCell",
                                                     for: indexPath) as! AdminGroupsTableViewCell
            
            cell.groupNameLabel.text = groups[indexPath.row].GroupName
            return cell
        } else if indexPath.section == 1 {
            return tableView.dequeueReusableCell(withIdentifier: "AdminGroupsFetchingCell", for: indexPath)
        } else if indexPath.section == 2 {
            return tableView.dequeueReusableCell(withIdentifier: "AdminGroupsEmptyCell", for: indexPath)
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AdminGroupsErrorMsgCell", for: indexPath) as! AdminGroupsErrorMsgTableViewCell
            cell.errorMsgLabel.text = fetchingErrorMsg
            return cell
        }
        
        return tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        store.dispatch(InitAdminGroupDetail(
            groupId: groups[indexPath.row].GroupId,
            groupName: groups[indexPath.row].GroupName
        ))
        store.dispatch(getAdminGroupMembers)
        
        performSegue(withIdentifier: "showGroupDetail", sender: self)
    }
    
}
