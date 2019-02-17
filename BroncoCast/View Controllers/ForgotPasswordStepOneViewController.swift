//
//  ForgotPasswordStepOneViewController.swift
//  BroncoCast
//
//  Created by Ken Schenke on 12/26/18.
//  Copyright © 2018 Ken Schenke. All rights reserved.
//

import UIKit
import InputMask
import ReSwift
import Alertift

class ForgotPasswordStepOneViewController: UIViewController, UITextFieldDelegate, TextFieldHelperDelegate,
    MaskedTextFieldDelegateListener, StoreSubscriber {

    var finding = false
    var findingErrorMsg = ""
    var found = false
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailHelpText: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var phoneHelpText: UILabel!
    @IBOutlet weak var findAccountButton: ActivityButton!
    
    var emailHelper : TextFieldHelper?
    var phoneHelper : TextFieldHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.subscribe(self)

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
        
        findAccountButton.activityLabel = "Finding"
    }
    
    func newState(state: AppState) {
        if finding != state.forgotPasswordState.finding {
            finding = state.forgotPasswordState.finding
            if finding {
                findAccountButton.showActivity()
            } else {
                findAccountButton.hideActivity()
            }
        }
        
        if findingErrorMsg != state.forgotPasswordState.findingErrorMsg {
            findingErrorMsg = state.forgotPasswordState.findingErrorMsg
            if !findingErrorMsg.isEmpty {
                Alertift.alert(title: "An Error Occurred", message: findingErrorMsg)
                    .action(.default("Ok"))
                    .show()
            }
        }
        
        if found != state.forgotPasswordState.found {
            found = state.forgotPasswordState.found
            if found {
                performSegue(withIdentifier: "showForgotPasswordStepTwo", sender: self)
            }
        }
    }
    
    func isEmailAddressValid() -> Bool {
        let value = emailTextField.text!
        let emailRegex = try! NSRegularExpression(pattern:
            "\\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}\\b")
        let range = NSRange(location: 0, length: value.utf16.count)
        return emailRegex.firstMatch(in: value, options: [], range: range) != nil
    }
    
    func isPhoneValid() -> Bool {
        let phone = getPhoneNumberDigitsOnly(phoneTextField.text!)
        
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

    @IBAction func findAccountPressed(_ sender: Any) {
        let phone = getPhoneNumberDigitsOnly(phoneTextField.text!)
        let email = emailTextField.text!
        
        if !phone.isEmpty && !isPhoneValid() {
            Alertift.alert(title: "Phone Number", message: "Please enter a valid phone number")
                .action(.default("Ok"))
                .show()
            return
        }
        
        if !email.isEmpty && !isEmailAddressValid() {
            Alertift.alert(title: "Email Address", message: "Please enter a valid email address")
                .action(.default("Ok"))
                .show()
            return
        }
        
        if !phone.isEmpty && !email.isEmpty {
            Alertift.alert(title: "One is Required", message: "Enter phone or email (but not both)")
                .action(.default("Ok"))
                .show()
            return
        }
        
        if phone.isEmpty && email.isEmpty {
            Alertift.alert(title: "One is Required", message: "Either a phone or email is required")
                .action(.default("Ok"))
                .show()
            return
        }
        
        store.dispatch(SetForgotPasswordEmail(email: email))
        store.dispatch(SetForgotPasswordPhone(phone: phone))
        store.dispatch(findAccount)
    }
}
