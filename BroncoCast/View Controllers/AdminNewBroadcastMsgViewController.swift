//
//  AdminNewBroadcastMsgViewController.swift
//  BroncoCast
//
//  Created by Ken Schenke on 2/9/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import UIKit
import ReSwift

class AdminNewBroadcastMsgViewController: UIViewController, StoreSubscriber {
    
    var editingMsg : AdminNewBroadcastEditingMsg = .none
    var message = ""
    var remainingCharsLabelColor : UIColor = .clear

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var remainingCharsLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.subscribe(self)
        textView.delegate = self
        
        remainingCharsLabel.text = "Type the message below"
        remainingCharsLabelColor = remainingCharsLabel.textColor
        
        textView.becomeFirstResponder()
    }

    func newState(state: AppState) {
        if editingMsg != state.adminNewBroadcastState.editingMsg {
            editingMsg = state.adminNewBroadcastState.editingMsg
            if editingMsg == .shortMsg {
                if message != state.adminNewBroadcastState.shortMsg {
                    message = state.adminNewBroadcastState.shortMsg
                }
                textView.text = message
                titleLabel.text = "Short Message"
            } else if editingMsg == .longMsg {
                if message != state.adminNewBroadcastState.longMsg {
                    message = state.adminNewBroadcastState.longMsg
                }
                textView.text = message
                titleLabel.text = "Long Message"
            }
        }
        
        if editingMsg == .shortMsg && message != state.adminNewBroadcastState.shortMsg {
            message = state.adminNewBroadcastState.shortMsg
            textView.text = message
        }
        
        if editingMsg == .longMsg && message != state.adminNewBroadcastState.longMsg {
            message = state.adminNewBroadcastState.longMsg
            textView.text = message
        }
    }
    
}

extension AdminNewBroadcastMsgViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        var maxChars = 0
        
        if editingMsg == .shortMsg {
            maxChars = 140
            store.dispatch(SetAdminNewBroadcastShortMsg(shortMsg: String(textView.text.prefix(maxChars))))
        } else if editingMsg == .longMsg {
            maxChars = 2048
            store.dispatch(SetAdminNewBroadcastLongMsg(longMsg: String(textView.text.prefix(maxChars))))
        } else {
            return
        }
        
        let remaining = maxChars - textView.text.count
        let pluralSuffix = abs(remaining) == 1 ? "" : "s"
        if remaining >= 0 {
            remainingCharsLabel.text = "\(remaining) character\(pluralSuffix) left"
            remainingCharsLabel.textColor = remainingCharsLabelColor
        } else {
            remainingCharsLabel.text = "\(abs(remaining)) character\(pluralSuffix) too many"
            remainingCharsLabel.textColor = .red
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        bottomConstraint.constant = 280
    }
    
}
