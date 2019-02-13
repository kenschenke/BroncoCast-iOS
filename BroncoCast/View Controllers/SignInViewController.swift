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
import FontAwesome_swift

class SignInViewController: UIViewController, UITextFieldDelegate, StoreSubscriber {

    var signingIn = false
    var errorMsg = ""
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: ActivityButton!
    @IBOutlet weak var registerButton: DesignableButton!
    @IBOutlet weak var forgotPasswordButton: DesignableButton!
    @IBOutlet weak var optionsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        store.subscribe(self)

        signInButton.activityLabel = "Signing In"

        optionsButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 22, style: .solid)
        optionsButton.setTitle(String.fontAwesomeIcon(name: .cogs), for: .normal)
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
    
    @IBAction func optionsButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "showSignInOptions", sender: self)
    }

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
