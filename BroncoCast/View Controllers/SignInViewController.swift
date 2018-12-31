//
//  SignInViewController.swift
//  BroncoCast
//
//  Created by Ken Schenke on 12/23/18.
//  Copyright © 2018 Ken Schenke. All rights reserved.
//

import UIKit
import ReSwift
import Alertift

class SignInViewController: UIViewController, UITextFieldDelegate, StoreSubscriber {

    var signingIn = false
    var errorMsg = ""
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: ActivityButton!
    @IBOutlet weak var registerButton: DesignableButton!
    @IBOutlet weak var forgotPasswordButton: DesignableButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        store.subscribe(self)

        signInButton.activityLabel = "Signing In"
    }
    
    @IBAction func showPasswordChanged(_ sender: Any) {
        passwordTextField.isSecureTextEntry.toggle()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if usernameTextField.isFirstResponder {
            passwordTextField.becomeFirstResponder()
        } else if passwordTextField.isFirstResponder {
            passwordTextField.resignFirstResponder()
        }
        
        return true
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        store.dispatch(SetSigningInUsername(username: usernameTextField.text!))
        store.dispatch(SetSigningInPassword(password: passwordTextField.text!))
        store.dispatch(signIn)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func newState(state: AppState) {
        if state.signInState.signingIn != signingIn {
            signingIn = state.signInState.signingIn
            if signingIn {
                signInButton.showActivity()
            } else {
                signInButton.hideActivity()
            }
            registerButton.isHidden = signingIn
            forgotPasswordButton.isHidden = signingIn
        }
        
        if state.signInState.errorMsg != errorMsg {
            errorMsg = state.signInState.errorMsg
            if !errorMsg.isEmpty {
                Alertift.alert(title: "An Error Occurred", message: errorMsg)
                    .action(.default("Ok"))
                    .show()
            }
        }
    }
}
