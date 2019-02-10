//
//  AdminNewBroadcastGroupMemberTableViewCell.swift
//  BroncoCast
//
//  Created by Ken Schenke on 2/9/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import UIKit
import FontAwesome_swift

class AdminNewBroadcastGroupMemberTableViewCell: UITableViewCell {
    
    @IBOutlet weak var checkLabel: UILabel!
    @IBOutlet weak var memberNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        checkLabel.font = UIFont.fontAwesome(ofSize: 22, style: .solid)
    }

}
