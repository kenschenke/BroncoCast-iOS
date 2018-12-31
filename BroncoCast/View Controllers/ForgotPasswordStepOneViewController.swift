//
//  ForgotPasswordStepOneViewController.swift
//  BroncoCast
//
//  Created by Ken Schenke on 12/26/18.
//  Copyright © 2018 Ken Schenke. All rights reserved.
//

import UIKit
import InputMask

class ForgotPasswordStepOneViewController: UIViewController, UITextFieldDelegate, TextFieldHelperDelegate,
    MaskedTextFieldDelegateListener {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailHelpText: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var phoneHelpText: UILabel!
    
    var emailHelper : TextFieldHelper?
    var phoneHelper : TextFieldHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        emailTextField.delegate = self
        
        emailHelper = TextFieldHelper(emailTextField)
        emailHelper?.delegate = self
        emailHelper?.label = emailLabel
        emailHelper?.helpTextLabel = emailHelpText
        
        phoneHelper = TextFieldHelper(phoneTextField)
        phoneHelper?.delegate = self
        phoneHelper?.label = phoneLabel
        phoneHelper?.helpTextLabel = phoneHelpText
        
        emailHelpText.text = ""
        phoneHelpText.text = ""
    }
    
    func getPhoneNumberDigitsOnly() -> String {
        let value = phoneTextField.text!
        
        if value.isEmpty {
            return ""
        }
        
        let phoneRegex = try! NSRegularExpression(pattern: "[^0-9]")
        let range = NSRange(location: 0, length: value.utf16.count)
        return phoneRegex.stringByReplacingMatches(in: value, options: [], range: range, withTemplate: "")
    }
    
    func isEmailAddressValid() -> Bool {
        let value = emailTextField.text!
        let emailRegex = try! NSRegularExpression(pattern:
            "\\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}\\b")
        let range = NSRange(location: 0, length: value.utf16.count)
        return emailRegex.firstMatch(in: value, options: [], range: range) != nil
    }
    
    func isPhoneValid() -> Bool {
        let phone = getPhoneNumberDigitsOnly()
        
        if phone.isEmpty {
            return true
        }
        
        return phone.count == 10
    }
    
    func setEmailInvalid() {
        emailHelper?.validContext = .invalid
        emailHelpText.text = "Email address not valid"
    }
    
    func setPhoneInvalid() {
        phoneHelper?.validContext = .invalid
        phoneHelpText.text = "Phone number must be 10 digits"
    }
    
    func textFieldHelper(_ textField: UITextField, idleTimeout value: String) {
        if textField == emailTextField {
            if !isEmailAddressValid() {
                setEmailInvalid()
            }
        } else if textField == phoneTextField {
            if !isPhoneValid() {
                setPhoneInvalid()
            }
        }
    }
    
    func textField(_ textField: UITextField, didFillMandatoryCharacters complete: Bool, didExtractValue value: String) {
        if textField == phoneTextField {
            phoneHelper?.textFieldChanged()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if emailTextField.isFirstResponder {
            emailTextField.resignFirstResponder()
        } else if phoneTextField.isFirstResponder {
            phoneTextField.resignFirstResponder()
        }
        
        return true
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
