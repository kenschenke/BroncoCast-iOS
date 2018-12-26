//
//  TextFieldHelper.swift
//  BroncoCast
//
//  Created by Ken Schenke on 12/23/18.
//  Copyright © 2018 Ken Schenke. All rights reserved.
//

import UIKit

protocol TextFieldHelperDelegate : class {
    func textFieldHelper(_ textField : UITextField, idleTimeout value : String)
    //    func input(_ input : Input, validate value : String)
}

class TextFieldHelper {
    var textField : UITextField
    var label : UILabel?
    var helpTextLabel : UILabel?

    enum ValidContext {
        case neutral
        case valid
        case invalid
    }
    
    weak var delegate : TextFieldHelperDelegate?
    
    var timer: Timer?
    
    init(_ textField : UITextField) {
        self.textField = textField
        self.textField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
    var validContext : ValidContext = .neutral {
        didSet {
            var color : UIColor
            
            switch self.validContext {
            case .neutral:
                color = UIColor.lightGray

            case .valid:
                color = UIColor.green

            case .invalid:
                color = UIColor.red
            }

            label?.textColor = color
            textField.layer.borderColor = color.cgColor
            helpTextLabel?.textColor = color
        }
    }
    
    @objc func textFieldChanged() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 3, target: self,
                                     selector: #selector(self.fireTimer),
                                     userInfo: nil, repeats: false)
        helpTextLabel?.text = ""
        validContext = .neutral
    }
    
    @objc func fireTimer() {
        delegate?.textFieldHelper(textField, idleTimeout: textField.text!)
    }
}
