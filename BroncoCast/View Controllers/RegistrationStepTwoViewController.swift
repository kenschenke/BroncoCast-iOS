//
//  RegistrationStepTwoViewController.swift
//  BroncoCast
//
//  Created by Ken Schenke on 12/26/18.
//  Copyright © 2018 Ken Schenke. All rights reserved.
//

import UIKit
import InputMask
import Alertift
import ReSwift

class RegistrationStepTwoViewController: UIViewController, UITextFieldDelegate, TextFieldHelperDelegate, MaskedTextFieldDelegateListener, StoreSubscriber {
    
    var registering = false
    var errorMsg = ""

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameHelpText: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var phoneHelpText: UILabel!
    @IBOutlet var phoneTextFieldListener: MaskedTextFieldDelegate!
    @IBOutlet weak var registerButton: ActivityButton!
    @IBOutlet weak var orgTagTextField: UITextField!
    
    var nameHelper : TextFieldHelper?
    var phoneHelper : TextFieldHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.subscribe(self)

        nameTextField.delegate = self
        
        nameHelper = TextFieldHelper(nameTextField)
        nameHelper?.delegate = self
        nameHelper?.label = nameLabel
        nameHelper?.helpTextLabel = nameHelpText
        
        phoneHelper = TextFieldHelper(phoneTextField)
        phoneHelper?.delegate = self
        phoneHelper?.label = phoneLabel
        phoneHelper?.helpTextLabel = phoneHelpText
        
        nameHelpText.text = ""
        phoneHelpText.text = ""
        
        registerButton.activityLabel = "Registering"
    }
    
    func newState(state: AppState) {
        if registering != state.registrationState.registering {
            registering = state.registrationState.registering
            if registering {
                registerButton.showActivity()
            } else {
                registerButton.hideActivity()
            }
        }
        
        if errorMsg != state.registrationState.errorMsg {
            errorMsg = state.registrationState.errorMsg
            if !errorMsg.isEmpty {
                Alertift.alert(title: "An Error Occurred", message: errorMsg)
                    .action(.default("Ok"))
                    .show()
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if nameTextField.isFirstResponder {
            phoneTextField.becomeFirstResponder()
        } else if phoneTextField.isFirstResponder {
            phoneTextField.resignFirstResponder()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, didFillMandatoryCharacters complete: Bool,
                   didExtractValue value: String) {
        if textField == phoneTextField {
            phoneHelper?.textFieldChanged()
        }
    }
    
    func isNameValid() -> Bool {
        let value = nameTextField.text!
        return value.count >= 5
    }
    
    func isPhoneValid() -> Bool {
        let phone = getPhoneNumberDigitsOnly(phoneTextField.text!)
        
        if phone.isEmpty {
            return true
        }
        
        return phone.count == 10
    }
    
    func setNameInvalid() {
        nameHelper?.validContext = .invalid
        nameHelpText.text = "Name must be at least 5 characters long"
    }
    
    func setPhoneInvalid() {
        phoneHelper?.validContext = .invalid
        phoneHelpText.text = "Phone number must be 10 digits"
    }
    
    func textFieldHelper(_ textField: UITextField, idleTimeout value: String) {
        if textField == nameTextField {
            if !isNameValid() {
                setNameInvalid()
            }
        } else if textField == phoneTextField {
            if !isPhoneValid() {
                setPhoneInvalid()
            }
        }
    }

    @IBAction func registerPressed(_ sender: Any) {
        if !isNameValid() {
            Alertift.alert(title: "Name", message: "Please enter a valid name")
                .action(.default("Ok"))
                .show()
            return
        }
        
        if !isPhoneValid() {
            Alertift.alert(title: "Phone Number", message: "Please enter a valid phone number")
                .action(.default("Ok"))
                .show()
            return
        }
        
        let orgTag = orgTagTextField.text!
        if orgTag.isEmpty {
            Alertift.alert(title: "Invite Code", message: "Invite code is required")
                .action(.default("Ok"))
                .show()
            return
        }
        
        store.dispatch(SetRegistrationName(name: nameTextField.text!))
        store.dispatch(SetRegistrationPhone(phone: getPhoneNumberDigitsOnly(phoneTextField.text!)))
        store.dispatch(SetRegistrationOrgTag(orgTag: orgTag))

        store.dispatch(registerUser)
    }
    
}
