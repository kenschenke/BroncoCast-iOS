//
//  RegistrationStepOneViewController.swift
//  BroncoCast
//
//  Created by Ken Schenke on 12/26/18.
//  Copyright © 2018 Ken Schenke. All rights reserved.
//

import UIKit
import ReSwift
import Alertift

class RegistrationStepOneViewController: UIViewController, UITextFieldDelegate, TextFieldHelperDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailHelpText: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordHelpText: UILabel!
    
    var emailHelper : TextFieldHelper?
    var passwordHelper : TextFieldHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        emailHelper = TextFieldHelper(emailTextField)
        emailHelper?.delegate = self
        emailHelper?.label = emailLabel
        emailHelper?.helpTextLabel = emailHelpText
        
        passwordHelper = TextFieldHelper(passwordTextField)
        passwordHelper?.delegate = self
        passwordHelper?.label = passwordLabel
        passwordHelper?.helpTextLabel = passwordHelpText
        
        emailHelpText.text = ""
        passwordHelpText.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if emailTextField.isFirstResponder {
            passwordTextField.becomeFirstResponder()
        } else if passwordTextField.isFirstResponder {
            passwordTextField.resignFirstResponder()
        }
        
        return true
    }
    
    func isPasswordValid() -> Bool {
        let value = passwordTextField.text!
        return value.count >= 5
    }
    
    func setEmailInvalid() {
        emailHelper?.validContext = .invalid
        emailHelpText.text = "Email address not valid"
    }
    
    func setPasswordInvalid() {
        passwordHelper?.validContext = .invalid
        passwordHelpText.text = "Password must be at 5 characters long"
    }
    
    func textFieldHelper(_ textField: UITextField, idleTimeout value: String) {
        if textField == emailTextField {
            if !isEmailAddressValid(emailTextField.text!) {
                setEmailInvalid()
            }
        } else if textField == passwordTextField {
            if !isPasswordValid() {
                setPasswordInvalid()
            }
        }
    }
    
    @IBAction func showPasswordChanged(_ sender: Any) {
        passwordTextField.isSecureTextEntry.toggle()
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        if !isEmailAddressValid(emailTextField.text!) {
            setEmailInvalid()
            Alertift.alert(title: "Email Address", message: "Please enter a valid email address")
                .action(.default("Ok"))
                .show()
            return
        }
        
        if !isPasswordValid() {
            setPasswordInvalid()
            Alertift.alert(title: "Password", message: "Please enter a valid password")
                .action(.default("Ok"))
                .show()
            return
        }
        
        store.dispatch(SetRegistrationEmail(email: emailTextField.text!))
        store.dispatch(SetRegistrationPassword(password: passwordTextField.text!))

        performSegue(withIdentifier: "showRegistrationStepTwo", sender: self)
    }
}
