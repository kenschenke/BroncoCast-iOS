//
//  RegistrationStepTwoViewController.swift
//  BroncoCast
//
//  Created by Ken Schenke on 12/26/18.
//  Copyright © 2018 Ken Schenke. All rights reserved.
//

import UIKit
import InputMask

class RegistrationStepTwoViewController: UIViewController, UITextFieldDelegate, TextFieldHelperDelegate, MaskedTextFieldDelegateListener {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameHelpText: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var phoneHelpText: UILabel!
    @IBOutlet var phoneTextFieldListener: MaskedTextFieldDelegate!
    
    var nameHelper : TextFieldHelper?
    var phoneHelper : TextFieldHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    func getPhoneNumberDigitsOnly() -> String {
        let value = phoneTextField.text!
        
        if value.isEmpty {
            return ""
        }
        
        let phoneRegex = try! NSRegularExpression(pattern: "[^0-9]")
        let range = NSRange(location: 0, length: value.utf16.count)
        return phoneRegex.stringByReplacingMatches(in: value, options: [], range: range, withTemplate: "")
    }
    
    func isNameValid() -> Bool {
        let value = nameTextField.text!
        return value.count >= 5
    }
    
    func isPhoneValid() -> Bool {
        let phone = getPhoneNumberDigitsOnly()
        
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
        store.dispatch(navigateTo(path: .profile_name))
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
