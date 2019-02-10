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
            tableView.reloadData()
        }
        
        if time != state.adminBroadcastDetailState.time {
            time = state.adminBroadcastDetailState.time
            tableView.reloadData()
        }
        
        if shortMsg != state.adminBroadcastDetailState.shortMsg {
            shortMsg = state.adminBroadcastDetailState.shortMsg
            tableView.reloadData()
        }
        
        if longMsg != state.adminBroadcastDetailState.longMsg {
            longMsg = state.adminBroadcastDetailState.longMsg
            tableView.reloadData()
        }
        
        if isDelivered != state.adminBroadcastDetailState.isDelivered {
            isDelivered = state.adminBroadcastDetailState.isDelivered
            tableView.reloadData()
            
            cancelButton.isEnabled = !isDelivered
            cancelButton.backgroundColor = isDelivered ? .darkGray : originalCancelButtonBkColor
        }
        
        if isCancelled != state.adminBroadcastDetailState.isCancelled {
            isCancelled = state.adminBroadcastDetailState.isCancelled
            tableView.reloadData()
        }
        
        if recipients != state.adminBroadcastDetailState.recipients {
            recipients = state.adminBroadcastDetailState.recipients
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
    
    // Row 0 - Status / Time
    // Row 1 - Sent By
    // Row 2 - Short Msg
    // Row 3 - Long Msg
    // Row 4 - Recipients
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BroadcastDetailCell", for: indexPath) as! AdminBroadcastDetailDataCell
        
        switch indexPath.row {
        case 0:  // status / time
            cell.titleLabel.text = "Status"
            if isCancelled {
                cell.contentLabel.text = "Cancelled"
            } else if isDelivered {
                cell.contentLabel.text = "Delivered at \(time)"
            } else {
                cell.contentLabel.text = "Scheduled for \(time)"
            }
            
        case 1:  // sent by
            cell.titleLabel.text = "Sent By"
            cell.contentLabel.text = sentBy
            
        case 2:  // short message
            cell.titleLabel.text = "Short Message"
            cell.contentLabel.text = shortMsg
            
        case 3:  // long message
            cell.titleLabel.text = "Long Message"
            cell.contentLabel.text = longMsg
            
        case 4:  // recipients
            cell.titleLabel.text = "Recipients"
            cell.contentLabel.text = recipients.joined(separator: ", ")
            
        default:
            break
        }
        
        return cell
    }
    
}
