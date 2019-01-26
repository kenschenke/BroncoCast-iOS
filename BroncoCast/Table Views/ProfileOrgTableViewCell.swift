//
//  ProfileOrgTableViewCell.swift
//  BroncoCast
//
//  Created by Ken Schenke on 1/22/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import UIKit
import FontAwesome_swift
import Alertift
import ReSwift

class ProfileOrgTableViewCell: UITableViewCell {

    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var orgNameLabel: UILabel!
    
    var memberId = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()

        removeButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 22, style: .solid)
        removeButton.setTitle(String.fontAwesomeIcon(name: .minusCircle), for: .normal)
    }
    
    @IBAction func removeButtonPressed(_ sender: Any) {
        Alertift.alert(title: "Confirm", message: "Drop this organization?")
            .action(.destructive("Drop")) { _, _, _ in
                store.dispatch(SetDropMemberId(memberId: self.memberId))
                store.dispatch(dropUserOrg)
            }
            .action(.cancel("Cancel"))
            .show()
    }
    
}
