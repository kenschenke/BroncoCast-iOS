//
//  AdminBroadcastsViewController.swift
//  BroncoCast
//
//  Created by Ken Schenke on 2/7/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import UIKit
import ReSwift

class AdminBroadcastsViewController: UIViewController, StoreSubscriber {
    
    var adminOrgId = 0
    var broadcasts : [AdminBroadcast] = []
    var fetching = false
    var fetchingErrorMsg = ""

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.subscribe(self)
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    func newState(state: AppState) {
        if broadcasts != state.adminBroadcastsState.broadcasts {
            broadcasts = state.adminBroadcastsState.broadcasts
            tableView.reloadData()
        }
        
        if fetching != state.adminBroadcastsState.fetchingBroadcasts {
            fetching = state.adminBroadcastsState.fetchingBroadcasts
            tableView.reloadData()
        }
        
        if fetchingErrorMsg != state.adminBroadcastsState.fetchingBroadcastsErrorMsg {
            fetchingErrorMsg = state.adminBroadcastsState.fetchingBroadcastsErrorMsg
            tableView.reloadData()
        }
        
        if adminOrgId != state.adminOrgState.adminOrgId {
            adminOrgId = state.adminOrgState.adminOrgId
            store.dispatch(getAdminBroadcasts)
        }
        
        if state.navigationState.dataRefreshNeeded &&
            state.navigationState.pathSegment == .admin_broadcasts_segment {
            
            store.dispatch(clearDataRefreshNeeded())
            if adminOrgId == state.adminOrgState.adminOrgId {
                store.dispatch(getAdminBroadcasts)
            }
        }
    }
    
    @IBAction func newBroadcastPressed(_ sender: Any) {
        store.dispatch(InitNewBroadcast())
        store.dispatch(getAdminBroadcastGroupMembers)
        
        performSegue(withIdentifier: "showNewBroadcast", sender: self)
    }
    
}

extension AdminBroadcastsViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Sections:
    //    0 - broadcasts
    //    1 - fetching message
    //    2 - empty table
    //    3 - error message
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return broadcasts.count
        } else if section == 1 && fetching {
            return 1
        } else if section == 2 && broadcasts.isEmpty && !fetching && fetchingErrorMsg.isEmpty {
            return 1
        } else if section == 3 && !fetchingErrorMsg.isEmpty {
            return 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AdminBroadcastsDetailCell",
                                                     for: indexPath) as! AdminBroadcastsDetailTableViewCell
            
            cell.sentLabel.text = broadcasts[indexPath.row].Time
            cell.shortMsgLabel.text = broadcasts[indexPath.row].ShortMsg
            return cell
        } else if indexPath.section == 1 {
            return tableView.dequeueReusableCell(withIdentifier: "AdminBroadcastsFetchingCell", for: indexPath)
        } else if indexPath.section == 2 {
            return tableView.dequeueReusableCell(withIdentifier: "AdminBroadcastsEmptyCell", for: indexPath)
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AdminBroadcastsErrorMsgCell", for: indexPath) as! AdminBroadcastsErrorMsgTableViewCell
            cell.errorMsgLabel.text = fetchingErrorMsg
            return cell
        }
        
        return tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        store.dispatch(SetAdminBroadcastDetails(
            broadcastId: broadcasts[indexPath.row].BroadcastId,
            sentBy: broadcasts[indexPath.row].SentBy,
            time: broadcasts[indexPath.row].Time,
            timestamp: broadcasts[indexPath.row].Timestamp,
            isDelivered: broadcasts[indexPath.row].IsDelivered,
            isCancelled: broadcasts[indexPath.row].IsCancelled,
            shortMsg: broadcasts[indexPath.row].ShortMsg,
            longMsg: broadcasts[indexPath.row].LongMsg,
            recipients: broadcasts[indexPath.row].Recipients
        ))
        
        performSegue(withIdentifier: "showAdminBroadcastDetail", sender: self)
    }
    
}
