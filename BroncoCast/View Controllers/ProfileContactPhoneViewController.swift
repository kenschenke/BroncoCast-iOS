//
//  ProfileContactPhoneViewController.swift
//  BroncoCast
//
//  Created by Ken Schenke on 1/19/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import UIKit
import ReSwift
import Alertift
import InputMask

class ProfileContactPhoneViewController: UIViewController, UITextFieldDelegate,
    TextFieldHelperDelegate, StoreSubscriber, MaskedTextFieldDelegateListener {

    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var phoneHelpText: UILabel!
    @IBOutlet weak var deleteContactButton: ActivityButton!
    @IBOutlet weak var sendTestButton: ActivityButton!
    @IBOutlet weak var saveButton: ActivityButton!
    @IBOutlet var phoneTextFieldListener: MaskedTextFieldDelegate!
    @IBOutlet weak var deleteAndTestStackView: UIStackView!

    var saved = false
    var contactId = 0
    var contactName = ""
    var initialContactName = ""
    var saving = false
    var errorMsg = ""
    var deleting = false
    var testing = false
    var testSent = false
    
    var phoneHelper : TextFieldHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        phoneField.delegate = phoneTextFieldListener
//        phoneField.delegate = self

        phoneHelper = TextFieldHelper(phoneField)
        phoneHelper?.delegate = self
        phoneHelper?.label = phoneLabel
        phoneHelper?.helpTextLabel = phoneHelpText
        
        phoneHelpText.text = ""
        
        saveButton.activityLabel = "Saving"
        deleteContactButton.activityLabel = "Deleting"
        sendTestButton.activityLabel = "Sending"
        
        deleteAndTestStackView.isHidden = true
        
        store.subscribe(self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if phoneField.isFirstResponder {
            phoneField.resignFirstResponder()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, didFillMandatoryCharacters complete: Bool, didExtractValue value: String) {
        if textField == phoneField {
            phoneHelper?.textFieldChanged()
        }
    }
    
    func setPhoneInvalid() {
        phoneHelper?.validContext = .invalid
        phoneHelpText.text = "Phone number must be 10 digits"
    }

    func textFieldHelper(_ textField: UITextField, idleTimeout value: String) {
        if textField == phoneField {
            if getPhoneNumberDigitsOnly(phoneField.text!).count == 10 {
                // Save the updated email address
            } else {
                setPhoneInvalid()
            }
        }
    }

    @IBAction func saveButtonPressed(_ sender: Any) {
        let phone = getPhoneNumberDigitsOnly(phoneField.text!)
        if phone.count != 10 {
            setPhoneInvalid()
            Alertift.alert(title: "An Error Occurred", message: "The phone number must be 10 digits")
                .action(.default("Ok"))
                .show()
            return
        }
        
        store.dispatch(SetProfileContactToEdit(contactId: contactId, contactName: phone))
        store.dispatch(saveProfileContact)
    }
    
    @IBAction func deleteContactPressed(_ sender: Any) {
        Alertift.alert(title: "Confirm", message: "Delete this contact?")
            .action(.destructive("Delete")) { _, _, _ in
                store.dispatch(deleteProfileContact)
            }
            .action(.cancel("Cancel"))
            .show()
    }
    
    @IBAction func sendTestPressed(_ sender: Any) {
        if initialContactName != getPhoneNumberDigitsOnly(phoneField.text!) {
            Alertift.alert(title: "New Contact", message: "You need to save first.")
                .action(.default("Ok"))
                .show()
            return
        }
        
        store.dispatch(testProfileContact)
    }
    
    func newState(state: AppState) {
        if state.profileContactsEditState.goBack != saved {
            saved = state.profileContactsEditState.goBack
            
            if saved {
                _ = navigationController?.popViewController(animated: true)
            }
        }
        
        if state.profileContactsEditState.contactId != contactId {
            contactId = state.profileContactsEditState.contactId
            if contactId != 0 {
                deleteAndTestStackView.isHidden = false
            }
        }
        
        if state.profileContactsEditState.contactName != contactName {
            contactName = state.profileContactsEditState.contactName
            phoneField.text = formatPhoneNumber(contactName)
            if initialContactName.isEmpty && !contactName.isEmpty {
                initialContactName = contactName
            }
        }
        
        if state.profileContactsEditState.saving != saving {
            saving = state.profileContactsEditState.saving
            if saving {
                saveButton.showActivity()
            } else {
                saveButton.hideActivity()
            }
        }
        
        if state.profileContactsEditState.deleting != deleting {
            deleting = state.profileContactsEditState.deleting
            if deleting {
                deleteContactButton.showActivity()
            } else {
                deleteContactButton.hideActivity()
            }
        }
        
        if state.profileContactsEditState.errorMsg != errorMsg {
            errorMsg = state.profileContactsEditState.errorMsg
            if !errorMsg.isEmpty {
                Alertift.alert(title: "An Error Occurred", message: errorMsg)
                    .action(.default("Ok"))
                    .show()
            }
        }
        
        if state.profileContactsEditState.testing != testing {
            testing = state.profileContactsEditState.testing
            if testing {
                sendTestButton.showActivity()
            } else {
                sendTestButton.hideActivity()
            }
        }
        
        if state.profileContactsEditState.testSent != testSent {
            testSent = state.profileContactsEditState.testSent
            if testSent {
                Alertift.alert(title: "Test Sent", message: "A test text message was sent")
                    .action(.default("Ok"))
                    .show()
            }
        }
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
