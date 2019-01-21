//
//  ProfileContactsSingleMsgTableViewCell.swift
//  BroncoCast
//
//  Created by Ken Schenke on 1/21/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import UIKit
import ReSwift

class ProfileContactsSingleMsgTableViewCell: UITableViewCell, StoreSubscriber {

    @IBOutlet weak var singleMsgSwitch: UISwitch!
    @IBOutlet weak var singleMsgLabel: UILabel!
    
    var singleMsg = true
    var saving = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        store.subscribe(self)
    }

    func newState(state: AppState) {
        if state.profileNameState.singleMsg != singleMsg {
            singleMsg = state.profileNameState.singleMsg
            singleMsgSwitch.isOn = singleMsg
        }
        
        if state.profileNameState.updating != saving {
            saving = state.profileNameState.updating
            singleMsgLabel.text = saving ? "Saving changes" : "Send single messages"
        }
    }

    @IBAction func singleMsgValueChanged(_ sender: Any) {
        store.dispatch(SetProfileSingleMsg(singleMsg: singleMsgSwitch.isOn))
        store.dispatch(saveProfile)
    }
}
