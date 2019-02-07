//
//  AdminGroupRemoveMembersDetailTableViewCell.swift
//  BroncoCast
//
//  Created by Ken Schenke on 2/7/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import UIKit
import FontAwesome_swift
import ReSwift

class AdminGroupRemoveMembersDetailTableViewCell: UITableViewCell {
    
    var memberId = 0

    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var memberNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        removeButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 22, style: .solid)
        removeButton.setTitle(String.fontAwesomeIcon(name: .minusCircle), for: .normal)
    }

    @IBAction func removeButtonPressed(_ sender: Any) {
        store.dispatch(SetAdminGroupDetailRemovingMemberId(removingMemberId: memberId))
        store.dispatch(removeGroupMember)
    }
    
}
