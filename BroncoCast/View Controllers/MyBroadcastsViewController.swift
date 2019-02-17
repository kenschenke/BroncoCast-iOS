//
//  MyBroadcastsViewController.swift
//  BroncoCast
//
//  Created by Ken Schenke on 1/1/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import UIKit
import ReSwift

class MyBroadcastsViewController: UIViewController, StoreSubscriber {

    var broadcasts : [Broadcast] = []
    var fetching = false
    var fetchingErrorMsg = ""
    var launchedBroadcastId = 0
    
    @IBOutlet weak var broadcastsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        broadcastsTable.dataSource = self
        broadcastsTable.delegate = self
        store.subscribe(self)
    }
    
    func newState(state: AppState) {
        if launchedBroadcastId != state.signInState.launchedBroadcastId {
            launchedBroadcastId = state.signInState.launchedBroadcastId
        }

        if state.userBroadcastsState.broadcasts != broadcasts {
            broadcasts = state.userBroadcastsState.broadcasts
            broadcastsTable.reloadData()
            
            if !broadcasts.isEmpty && launchedBroadcastId != 0 {
                for (index, broadcast) in broadcasts.enumerated() {
                    if broadcast.broadcastId == launchedBroadcastId {
                        store.dispatch(SetLaunchedBroadcastId(broadcastId: 0))
                        viewBroadcast(row: index)
                        break
                    }
                }
            }
        }
        
        if fetching != state.userBroadcastsState.fetching {
            fetching = state.userBroadcastsState.fetching
            broadcastsTable.reloadData()
        }
        
        if fetchingErrorMsg != state.userBroadcastsState.errorMsg {
            fetchingErrorMsg = state.userBroadcastsState.errorMsg
            broadcastsTable.reloadData()
        }

        if state.navigationState.dataRefreshNeeded &&
            state.navigationState.pathSegment == .segment_none {
            
            store.dispatch(clearDataRefreshNeeded())
            store.dispatch(getUserBroadcasts)
            self.navigationController?.navigationBar.topItem?.title = "Broadcasts"
        }
    }

}

extension MyBroadcastsViewController: UITableViewDelegate, UITableViewDataSource {

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
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserBroadcastsTableCell",
                                                           for: indexPath) as! UserBroadcastTableViewCell
            
            cell.sentLabel.text = broadcasts[indexPath.row].delivered
            cell.shortMsgLabel.text = broadcasts[indexPath.row].shortMsg
            
            return cell
        } else if indexPath.section == 1 {
            return tableView.dequeueReusableCell(withIdentifier: "UserBroadcastsFetchingCell", for: indexPath)
        } else if indexPath.section == 2 {
            return tableView.dequeueReusableCell(withIdentifier: "UserBroadcastsEmptyCell", for: indexPath)
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserBroadcastsErrorCell", for: indexPath) as! UserBroadcastErrorTableViewCell
            cell.errorLabel.text = fetchingErrorMsg
            return cell
        }
        
        return tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewBroadcast(row: indexPath.row)
    }
    
    func viewBroadcast(row: Int) {
        store.dispatch(SetUserBroadcastDetailSentBy(sentBy: broadcasts[row].sentBy))
        store.dispatch(SetUserBroadcastDetailDelivered(delivered: broadcasts[row].delivered))
        store.dispatch(SetUserBroadcastDetailShortMsg(shortMsg: broadcasts[row].shortMsg))
        store.dispatch(SetUserBroadcastDetailLongMsg(longMsg: broadcasts[row].longMsg))
        
        performSegue(withIdentifier: "UserBroadcastDetail", sender: self)
    }

}
