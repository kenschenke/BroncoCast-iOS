//
//  AdminBroadcastDetailViewController.swift
//  BroncoCast
//
//  Created by Ken Schenke on 2/8/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import UIKit
import ReSwift
import Alertift

struct AdminBroadcastDetailRow {
    var Title : String
    var Content : String
}

class AdminBroadcastDetailViewController: UIViewController, StoreSubscriber {
    
    var sentBy = ""
    var time = ""
    var shortMsg = ""
    var longMsg = ""
    var isDelivered = false
    var isCancelled = false
    var recipients : [String] = []
    var cancelling = false
    var cancellingErrorMsg = ""
    var originalCancelButtonBkColor : UIColor = .clear
    var Rows : [AdminBroadcastDetailRow] = []

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelButton: ActivityButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.subscribe(self)
        tableView.delegate = self
        tableView.dataSource = self
        
        cancelButton.activityLabel = "Cancelling"
        
        originalCancelButtonBkColor = cancelButton.backgroundColor!
    }

    func newState(state: AppState) {
        if sentBy != state.adminBroadcastDetailState.sentBy {
            sentBy = state.adminBroadcastDetailState.sentBy
            updateRows()
            tableView.reloadData()
        }
        
        if time != state.adminBroadcastDetailState.time {
            time = state.adminBroadcastDetailState.time
            updateRows()
            tableView.reloadData()
        }
        
        if shortMsg != state.adminBroadcastDetailState.shortMsg {
            shortMsg = state.adminBroadcastDetailState.shortMsg
            updateRows()
            tableView.reloadData()
        }
        
        if longMsg != state.adminBroadcastDetailState.longMsg {
            longMsg = state.adminBroadcastDetailState.longMsg
            updateRows()
            tableView.reloadData()
        }
        
        if isDelivered != state.adminBroadcastDetailState.isDelivered {
            isDelivered = state.adminBroadcastDetailState.isDelivered
            updateRows()
            tableView.reloadData()
            
            cancelButton.isEnabled = !isDelivered
            cancelButton.backgroundColor = isDelivered ? .darkGray : originalCancelButtonBkColor
        }
        
        if isCancelled != state.adminBroadcastDetailState.isCancelled {
            isCancelled = state.adminBroadcastDetailState.isCancelled
            updateRows()
            tableView.reloadData()
        }
        
        if recipients != state.adminBroadcastDetailState.recipients {
            recipients = state.adminBroadcastDetailState.recipients
            updateRows()
            tableView.reloadData()
        }
        
        if cancelling != state.adminBroadcastDetailState.cancelling {
            cancelling = state.adminBroadcastDetailState.cancelling
            if cancelling {
                cancelButton.showActivity()
            } else {
                cancelButton.hideActivity()
            }
        }
        
        if cancellingErrorMsg != state.adminBroadcastDetailState.cancellingErrorMsg {
            cancellingErrorMsg = state.adminBroadcastDetailState.cancellingErrorMsg
            if !cancellingErrorMsg.isEmpty {
                Alertift.alert(title: "An Error Occurred", message: cancellingErrorMsg)
                    .action(.default("Ok"))
                    .show()
            }
        }
    }

    @IBAction func cancelButtonPressed(_ sender: Any) {
        store.dispatch(cancelBroadcast)
    }
}

extension AdminBroadcastDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BroadcastDetailCell", for: indexPath) as! AdminBroadcastDetailDataCell
        
        cell.titleLabel.text = Rows[indexPath.row].Title
        cell.contentLabel.text = Rows[indexPath.row].Content
        
        return cell
    }
    
    func updateRows() {
        Rows = []
        
        var statusText = ""
        if isCancelled {
            statusText = "Cancelled"
        } else if isDelivered {
            statusText = "Delivered at \(time)"
        } else {
            statusText = "Scheduled for \(time)"
        }
        Rows.append(AdminBroadcastDetailRow(Title: "Status", Content: statusText))
        Rows.append(AdminBroadcastDetailRow(Title: "Sent By", Content: sentBy))
        Rows.append(AdminBroadcastDetailRow(Title: "Short Msg", Content: shortMsg))
        
        if !longMsg.isEmpty {
            Rows.append(AdminBroadcastDetailRow(Title: "Long Msg", Content: longMsg))
        }

        Rows.append(AdminBroadcastDetailRow(
            Title: "Recipients",
            Content: recipients.joined(separator: ", ")
        ))
    }
    
}
