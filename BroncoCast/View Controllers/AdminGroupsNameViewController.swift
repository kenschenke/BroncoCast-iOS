//
//  AdminGroupsNameViewController.swift
//  BroncoCast
//
//  Created by Ken Schenke on 2/3/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import UIKit
import ReSwift

class AdminGroupsNameViewController: UIViewController, StoreSubscriber, TextFieldHelperDelegate {
    
    var groupNameHelper : TextFieldHelper?
    var groupId = 0
    var groupName = ""
    var saving = false
    var savingErrorMsg = ""
    var goBack = false

    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var saveButton: ActivityButton!
    @IBOutlet weak var groupNameHelpText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupNameHelper = TextFieldHelper(groupNameTextField)
        groupNameHelper?.label = groupNameLabel
        groupNameHelper?.helpTextLabel = groupNameHelpText
        groupNameHelper?.delegate = self
        
        groupNameHelpText.text = ""
        
        saveButton.activityLabel = "Creating New Group"
        
        store.subscribe(self)
    }
    
    func newState(state: AppState) {
        if groupId != state.adminGroupNameState.groupId {
            groupId = state.adminGroupNameState.groupId
            if groupId != 0 {
                saveButton.activityLabel = "Renaming Group"
            }
        }
        
        if groupName != state.adminGroupNameState.groupName {
            groupName = state.adminGroupNameState.groupName
            groupNameTextField.text = groupName
        }
        
        if saving != state.adminGroupNameState.saving {
            saving = state.adminGroupNameState.saving
            if saving {
                saveButton.showActivity()
            } else {
                saveButton.hideActivity()
            }
        }
        
        if savingErrorMsg != state.adminGroupNameState.savingErrorMsg {
            savingErrorMsg = state.adminGroupNameState.savingErrorMsg
            if !savingErrorMsg.isEmpty {
                groupNameHelper?.validContext = .invalid
                groupNameHelpText.text = savingErrorMsg
            }
        }
        
        if goBack != state.adminGroupNameState.goBack {
            goBack = state.adminGroupNameState.goBack
            if goBack {
                _ = navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        let name = groupNameTextField.text!
        if name.isEmpty {
            groupNameHelper?.validContext = .invalid
            groupNameHelpText.text = "Group name cannot be empty"
            return
        }
        
        store.dispatch(SetAdminGroupName(groupName: name))
        store.dispatch(adminGroupSaveName)
    }

    func textFieldHelper(_ textField: UITextField, idleTimeout value: String) {
        groupNameTextField.resignFirstResponder()
        if value.isEmpty {
            groupNameHelper?.validContext = .invalid
            groupNameHelpText.text = "Group name cannot be empty"
        }
    }

}
