//
//  ProfileOrgsErrorMsgTableViewCell.swift
//  BroncoCast
//
//  Created by Ken Schenke on 1/21/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import UIKit
import ReSwift

class ProfileOrgsErrorMsgTableViewCell: UITableViewCell, StoreSubscriber {

    @IBOutlet weak var errorMsgLabel: UILabel!
    
    var errorMsg = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        store.subscribe(self)
    }

    func newState(state: AppState) {
        if state.profileOrgsState.userOrgsErrorMsg != errorMsg {
            errorMsg = state.profileOrgsState.userOrgsErrorMsg
            errorMsgLabel.text = errorMsg
        }
    }

}
