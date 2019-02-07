//
//  AdminGroupAddMembersDetailTableViewCell.swift
//  BroncoCast
//
//  Created by Ken Schenke on 2/5/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import UIKit
import FontAwesome_swift
import ReSwift

class AdminGroupAddMembersDetailTableViewCell: UITableViewCell {
    
    var userId = 0

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        addButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 22, style: .solid)
        addButton.setTitle(String.fontAwesomeIcon(name: .plusCircle), for: .normal)
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        store.dispatch(SetAdminGroupDetailAddingUserId(addingUserId: userId))
        store.dispatch(addGroupMember)
    }
    
}
