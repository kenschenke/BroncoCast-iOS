//
//  UserBroadcastDetailViewController.swift
//  BroncoCast
//
//  Created by Ken Schenke on 1/1/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import UIKit
import ReSwift

struct UserBroadcastDetailRow {
    var Title : String
    var Content : String
}

class UserBroadcastDetailViewController: UIViewController, StoreSubscriber {

    var sentBy = ""
    var delivered = ""
    var shortMsg = ""
    var longMsg = "*** PLACEHOLDER ***"
    var Rows : [UserBroadcastDetailRow] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        store.subscribe(self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func newState(state: AppState) {
        if state.userBroadcastDetailState.sentBy != sentBy {
            sentBy = state.userBroadcastDetailState.sentBy
            updateRows()
            tableView.reloadData()
        }
        
        if state.userBroadcastDetailState.delivered != delivered {
            delivered = state.userBroadcastDetailState.delivered
            updateRows()
            tableView.reloadData()
        }
        
        if state.userBroadcastDetailState.shortMsg != shortMsg {
            shortMsg = state.userBroadcastDetailState.shortMsg
            updateRows()
            tableView.reloadData()
        }
        
        if state.userBroadcastDetailState.longMsg != longMsg {
            longMsg = state.userBroadcastDetailState.longMsg
            updateRows()
            tableView.reloadData()
        }
    }
}

extension UserBroadcastDetailViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UeerBroadcastDetailTableViewCell", for: indexPath) as! UserBroadcastDetailTableViewCell
        
        cell.titleLabel.text = Rows[indexPath.row].Title
        cell.contentLabel.text = Rows[indexPath.row].Content
        
        return cell
    }
    
    func updateRows() {
        Rows = []
        
        Rows.append(UserBroadcastDetailRow(Title: "Sent By", Content: sentBy))
        Rows.append(UserBroadcastDetailRow(Title: "Delivered", Content: delivered))
        Rows.append(UserBroadcastDetailRow(Title: "Short Msg", Content: shortMsg))
        
        if !longMsg.isEmpty {
            Rows.append(UserBroadcastDetailRow(Title: "Long Msg", Content: longMsg))
        }
    }

}
