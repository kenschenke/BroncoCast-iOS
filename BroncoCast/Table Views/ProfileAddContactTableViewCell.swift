//
//  ProfileAddContactTableViewCell.swift
//  BroncoCast
//
//  Created by Ken Schenke on 1/16/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import UIKit
import FontAwesome_swift

class ProfileAddContactTableViewCell: UITableViewCell {

    @IBOutlet weak var addPhoneButton: UIButton!
    @IBOutlet weak var addEmailButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        addPhoneButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 22, style: .solid)
        addPhoneButton.setTitle(String.fontAwesomeIcon(name: .plusCircle), for: .normal)
        
        addEmailButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 22, style: .solid)
        addEmailButton.setTitle(String.fontAwesomeIcon(name: .plusCircle), for: .normal)
    }
}
