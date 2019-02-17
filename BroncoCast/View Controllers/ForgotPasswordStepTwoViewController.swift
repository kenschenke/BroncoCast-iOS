//
//  ForgotPasswordStepTwoViewController.swift
//  BroncoCast
//
//  Created by Ken Schenke on 12/26/18.
//  Copyright © 2018 Ken Schenke. All rights reserved.
//

import UIKit
import ReSwift
import Alertift

class ForgotPasswordStepTwoViewController: UIViewController, StoreSubscriber {
    
    var recovering = false
    var errorMsg = ""
    var recovered = false

    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var resetPasswordButton: ActivityButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetPasswordButton.activityLabel = "Resetting"
        
        store.subscribe(self)
    }
    
    func newState(state: AppState) {
        if recovering != state.forgotPasswordState.recovering {
            recovering = state.forgotPasswordState.recovering
            if recovering {
                resetPasswordButton.showActivity()
            } else {
                resetPasswordButton.hideActivity()
            }
        }
        
        if errorMsg != state.forgotPasswordState.recoveringErrorMsg {
            errorMsg = state.forgotPasswordState.recoveringErrorMsg
            if !errorMsg.isEmpty {
                Alertift.alert(title: "An Error Occurred", message: errorMsg)
                    .action(.default("Ok"))
                    .show()
            }
        }
        
        if recovered != state.forgotPasswordState.recovered {
            recovered = state.forgotPasswordState.recovered
            if recovered {
                Alertift.alert(title: "Password Reset", message: "Your password has been reset")
                    .action(.default("Ok")) { _, _, _ in
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                    .show()
            }
        }
    }
    
    @IBAction func showPasswordChanged(_ sender: Any) {
        passwordTextField.isSecureTextEntry.toggle()
    }
    
    @IBAction func resetPasswordPressed(_ sender: Any) {
        store.dispatch(SetForgotPasswordCode(code: codeTextField.text!))
        store.dispatch(SetForgotPasswordNewPassword(password: passwordTextField.text!))
        store.dispatch(resetPassword)
    }
}
