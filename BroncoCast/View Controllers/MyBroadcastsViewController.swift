//
//  MyBroadcastsViewController.swift
//  BroncoCast
//
//  Created by Ken Schenke on 1/1/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import UIKit
import ReSwift

class MyBroadcastsViewController: UIViewController, UITableViewDataSource, StoreSubscriber, UITableViewDelegate {

    var broadcasts : [Broadcast] = []
    
    @IBOutlet weak var broadcastsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        broadcastsTable.dataSource = self
        broadcastsTable.delegate = self
        store.subscribe(self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return broadcasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = broadcastsTable.dequeueReusableCell(withIdentifier: "UserBroadcastsTableCell",
                                                       for: indexPath) as! UserBroadcastTableViewCell
        
        cell.sentLabel.text = broadcasts[indexPath.row].delivered
        cell.shortMsgLabel.text = broadcasts[indexPath.row].shortMsg
//        cell.textLabel?.text = broadcasts[indexPath.row].shortMsg
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        store.dispatch(SetUserBroadcastDetailSentBy(sentBy: broadcasts[indexPath.row].sentBy))
        store.dispatch(SetUserBroadcastDetailDelivered(delivered: broadcasts[indexPath.row].delivered))
        store.dispatch(SetUserBroadcastDetailShortMsg(shortMsg: broadcasts[indexPath.row].shortMsg))
        store.dispatch(SetUserBroadcastDetailLongMsg(longMsg: broadcasts[indexPath.row].longMsg))

        performSegue(withIdentifier: "UserBroadcastDetail", sender: self)
    }
    
    func newState(state: AppState) {
        if state.navigationState.dataRefreshNeeded &&
            state.navigationState.pathSegment == .segment_none {
            
            store.dispatch(clearDataRefreshNeeded())
            store.dispatch(getUserBroadcasts)
        }
        
        if state.userBroadcastsState.broadcasts != broadcasts {
            broadcasts = state.userBroadcastsState.broadcasts
            broadcastsTable.reloadData()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
