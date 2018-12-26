//
//  RegistrationStepOneViewController.swift
//  BroncoCast
//
//  Created by Ken Schenke on 12/26/18.
//  Copyright © 2018 Ken Schenke. All rights reserved.
//

import UIKit

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
    
    func isEmailAddressValid() -> Bool {
        let value = emailTextField.text!
        let emailRegex = try! NSRegularExpression(pattern:
            "\\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}\\b")
        let range = NSRange(location: 0, length: value.utf16.count)
        return emailRegex.firstMatch(in: value, options: [], range: range) != nil
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
            if !isEmailAddressValid() {
                setEmailInvalid()
            }
        } else if textField == passwordTextField {
            if !isPasswordValid() {
                setPasswordInvalid()
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if !isEmailAddressValid() {
            setEmailInvalid()
            return false
        }
        
        if !isPasswordValid() {
            setPasswordInvalid()
            return false
        }
        
        return true
    }
    
    @IBAction func showPasswordChanged(_ sender: Any) {
        passwordTextField.isSecureTextEntry.toggle()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
