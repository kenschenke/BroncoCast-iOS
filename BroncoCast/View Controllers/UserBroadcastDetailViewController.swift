//
//  UserBroadcastDetailViewController.swift
//  BroncoCast
//
//  Created by Ken Schenke on 1/1/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import UIKit
import ReSwift

class UserBroadcastDetailViewController: UIViewController, StoreSubscriber {

    var sentBy = ""
    var delivered = ""
    var shortMsg = ""
    var longMsg = "*** PLACEHOLDER ***"
    
    @IBOutlet weak var sentByLabel: UILabel!
    @IBOutlet weak var deliveredLabel: UILabel!
    @IBOutlet weak var shortMsgLabel: UILabel!
    @IBOutlet weak var longMsgLabel: UILabel!
    @IBOutlet weak var longMsgView: DesignableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        store.subscribe(self)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func newState(state: AppState) {
        if state.userBroadcastDetailState.sentBy != sentBy {
            sentBy = state.userBroadcastDetailState.sentBy
            sentByLabel.text = sentBy
        }
        
        if state.userBroadcastDetailState.delivered != delivered {
            delivered = state.userBroadcastDetailState.delivered
            deliveredLabel.text = delivered
        }
        
        if state.userBroadcastDetailState.shortMsg != shortMsg {
            shortMsg = state.userBroadcastDetailState.shortMsg
            shortMsgLabel.text = shortMsg
        }
        
        if state.userBroadcastDetailState.longMsg != longMsg {
            longMsg = state.userBroadcastDetailState.longMsg
            longMsgLabel.text = longMsg
            longMsgView.isHidden = longMsg.isEmpty
        }
    }
}
