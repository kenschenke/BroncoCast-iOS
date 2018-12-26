//
//  Input.swift
//  Text Input Idle Timeout
//
//  Created by Ken Schenke on 12/16/18.
//  Copyright © 2018 Ken Schenke. All rights reserved.
//

import UIKit

/*
protocol InputDelegate : class {
    func input(_ input : Input, idleTimeout value : String)
//    func input(_ input : Input, validate value : String)
}

class Input: UIView {
    
    enum HelpContext {
        case neutral
        case valid
        case invalid
    }
    
    weak var delegate : InputDelegate?

    var timer: Timer?
    
    var helpTextContext : HelpContext = .neutral {
        didSet {
            switch self.helpTextContext {
            case .neutral:
                helpTextLabel.textColor = UIColor.lightGray
            case .valid:
                helpTextLabel.textColor = UIColor.green
            case .invalid:
                helpTextLabel.textColor = UIColor.red
            }
        }
    }
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var helpTextLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("Input", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        textField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }

    @objc func textFieldChanged() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 3, target: self,
                                     selector: #selector(self.fireTimer),
                                     userInfo: nil, repeats: false)
        helpTextLabel.text = ""
    }
    
    @objc func fireTimer() {
        delegate?.input(self, idleTimeout: textField.text!)
    }
}
*/

