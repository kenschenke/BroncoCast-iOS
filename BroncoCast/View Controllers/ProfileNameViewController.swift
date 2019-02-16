//
//  ProfileNameViewController.swift
//  BroncoCast
//
//  Created by Ken Schenke on 12/31/18.
//  Copyright © 2018 Ken Schenke. All rights reserved.
//

import UIKit
import ReSwift

class ProfileNameViewController: UIViewController, StoreSubscriber, TextFieldHelperDelegate {

    var nameHelper : TextFieldHelper?
    var name = ""
    var getting = false
    var updating = false
    var saved = false
    var errorMsg = ""
    var onScreen = false
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameHelpText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        store.subscribe(self)
        
        nameHelper = TextFieldHelper(nameTextField)
        nameHelper?.label = nameLabel
        nameHelper?.helpTextLabel = nameHelpText
        nameHelper?.delegate = self
    }
    
    func newState(state: AppState) {
        if state.navigationState.dataRefreshNeeded &&
            state.navigationState.pathSegment == .profile_name_segment {

            store.dispatch(clearDataRefreshNeeded())
            store.dispatch(getProfile)
            self.title = "Name"
            self.navigationItem.title = "Name"
            self.navigationController?.navigationItem.title = "Name"
            onScreen = true
        }
        
        if state.navigationState.pathTab != .main_profile_tab ||
            state.navigationState.pathSegment != .profile_name_segment {
            if onScreen {
                onScreen = false
                nameTextField.resignFirstResponder()
            }
        }
        
        if state.profileNameState.name != name {
            name = state.profileNameState.name
            nameTextField.text = name
            store.dispatch(SetProfileSaved(saved: false))
        }
        
        if state.profileNameState.getting != getting {
            getting = state.profileNameState.getting
            nameHelpText.text = getting ? "Retrieving Name" : ""
        }
        
        if state.profileNameState.updating != updating {
            updating = state.profileNameState.updating
            if updating {
                nameHelpText.text = "Saving Name"
            }
        }
        
        if state.profileNameState.saved != saved {
            saved = state.profileNameState.saved
            if saved {
                nameHelpText.text = "Saved"
            }
        }
        
        if state.profileNameState.errorMsg != errorMsg {
            errorMsg = state.profileNameState.errorMsg
            if !errorMsg.isEmpty {
                nameHelpText.text = errorMsg
                nameHelper?.validContext = .invalid
            }
        }
    }
    
    func textFieldHelper(_ textField: UITextField, idleTimeout value: String) {
        name = value
        nameTextField.resignFirstResponder()
        store.dispatch(SetProfileName(name: value))
        if value.isEmpty {
            nameHelpText.text = "Name cannot be empty"
            nameHelper?.validContext = .invalid
        } else {
            store.dispatch(saveProfile)
        }
    }
    
}
