//
//  AdminUsersDetailViewController.swift
//  BroncoCast
//
//  Created by Ken Schenke on 2/2/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import UIKit
import ReSwift
import Alertift

class AdminUsersDetailViewController: UIViewController {
    
    var nameHelper : TextFieldHelper?
    var memberId = 0
    var userName = ""
    var goBack = false
    var isHidden = false
    var isAdmin = false
    var isApproved = false
    var contacts : [UserContact] = []
    var hidingUser = false
    var hidingErrorMsg = ""
    var settingAdmin = false
    var settingAdminErrorMsg = ""
    var savingName = false
    var savingNameErrorMsg = ""
    var nameSaved = false
    var removing = false
    var removingErrorMsg = ""
    var approving = false
    var approvingErrorMsg = ""
    var approveSuccess = false

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameHelpText: UILabel!
    @IBOutlet weak var hideButton: ActivityButton!
    @IBOutlet weak var adminButton: ActivityButton!
    @IBOutlet weak var removeButton: ActivityButton!
    @IBOutlet weak var contactDetail: UILabel!
    @IBOutlet weak var approveUserButton: ActivityButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.subscribe(self)
        
        nameHelper = TextFieldHelper(nameTextField)
        nameHelper?.label = nameLabel
        nameHelper?.helpTextLabel = nameHelpText
        nameHelper?.delegate = self
        nameHelpText.text = ""
        
        hideButton.activityLabel = "Hiding"
        adminButton.activityLabel = "Setting"
        removeButton.activityLabel = "Removing User"
        approveUserButton.activityLabel = "Approving User"
    }
    
    @IBAction func hideButtonPressed(_ sender: Any) {
        store.dispatch(adminHideUser)
    }
    
    @IBAction func adminButtonPressed(_ sender: Any) {
        store.dispatch(adminUserSetAdmin)
    }
    
    @IBAction func removeButtonPressed(_ sender: Any) {
        Alertift.alert(title: "Confirm", message: "Permanently remove user?")
            .action(.destructive("Delete")) { _, _, _ in
                store.dispatch(adminRemoveUser)
            }
            .action(.cancel("Cancel"))
            .show()
    }
    
    @IBAction func approveButtonPressed(_ sender: Any) {
        store.dispatch(adminApproveUser)
    }
}

extension AdminUsersDetailViewController : StoreSubscriber {

    func newState(state: AppState) {
        if memberId != state.adminUserDetailState.memberId {
            memberId = state.adminUserDetailState.memberId
        }
        
        if userName != state.adminUserDetailState.userName {
            userName = state.adminUserDetailState.userName
            nameTextField.text = userName
        }
        
        if goBack != state.adminUserDetailState.goBack {
            goBack = state.adminUserDetailState.goBack
            if goBack {
                _ = navigationController?.popViewController(animated: true)
            }
        }
        
        if isHidden != state.adminUserDetailState.isHidden {
            isHidden = state.adminUserDetailState.isHidden
            hideButton.setTitle(isHidden ? "Unhide User" : "Hide User", for: .normal)
        }
        
        if isAdmin != state.adminUserDetailState.isAdmin {
            isAdmin = state.adminUserDetailState.isAdmin
            adminButton.setTitle(isAdmin ? "Remove Admin" : "Set Admin", for: .normal)
        }
        
        if isApproved != state.adminUserDetailState.isApproved {
            isApproved = state.adminUserDetailState.isApproved
            if isApproved {
                approveUserButton.isHidden = true
            }
        }
        
        if contacts != state.adminUserDetailState.contacts {
            contacts = state.adminUserDetailState.contacts
            var detail = ""
            for contact in contacts {
                if !detail.isEmpty {
                    detail += "\n"
                }
                if isPhoneNumber(contact.ContactName) {
                    detail += formatPhoneNumber(contact.ContactName)
                } else {
                    detail += contact.ContactName
                }
            }
            contactDetail.text = detail
        }
        
        if hidingUser != state.adminUserDetailState.hidingUser {
            hidingUser = state.adminUserDetailState.hidingUser
            if hidingUser {
                hideButton.showActivity()
            } else {
                hideButton.hideActivity()
            }
        }
        
        if hidingErrorMsg != state.adminUserDetailState.hidingErrorMsg {
            hidingErrorMsg = state.adminUserDetailState.hidingErrorMsg
            if !hidingErrorMsg.isEmpty {
                Alertift.alert(title: "An Error Occurred", message: hidingErrorMsg)
                    .action(.default("Ok"))
                    .show()
            }
        }
        
        if settingAdmin != state.adminUserDetailState.settingAdmin {
            settingAdmin = state.adminUserDetailState.settingAdmin
            if settingAdmin {
                adminButton.showActivity()
            } else {
                adminButton.hideActivity()
            }
        }
        
        if settingAdminErrorMsg != state.adminUserDetailState.settingAdminErrorMsg {
            settingAdminErrorMsg = state.adminUserDetailState.settingAdminErrorMsg
            if !settingAdminErrorMsg.isEmpty {
                Alertift.alert(title: "An Error Occurred", message: settingAdminErrorMsg)
                    .action(.default("Ok"))
                    .show()
            }
        }
        
        if savingName != state.adminUserDetailState.savingName {
            savingName = state.adminUserDetailState.savingName
            if savingName {
                nameHelpText.text = "Saving"
            }
        }
        
        if savingNameErrorMsg != state.adminUserDetailState.savingNameErrorMsg {
            savingNameErrorMsg = state.adminUserDetailState.savingNameErrorMsg
            if !savingNameErrorMsg.isEmpty {
                nameHelpText.text = savingNameErrorMsg
                nameHelper?.validContext = .invalid
            }
        }
        
        if nameSaved != state.adminUserDetailState.nameSaved {
            nameSaved = state.adminUserDetailState.nameSaved
            if nameSaved {
                nameHelpText.text = "Saved"
            }
        }
        
        if removing != state.adminUserDetailState.removing {
            removing = state.adminUserDetailState.removing
            if removing {
                removeButton.showActivity()
            } else {
                removeButton.hideActivity()
            }
        }
        
        if removingErrorMsg != state.adminUserDetailState.removingErrorMsg {
            removingErrorMsg = state.adminUserDetailState.removingErrorMsg
            if !removingErrorMsg.isEmpty {
                Alertift.alert(title: "An Error Occurred", message: removingErrorMsg)
                    .action(.default("Ok"))
                    .show()
            }
        }
        
        if approving != state.adminUserDetailState.approving {
            approving = state.adminUserDetailState.approving
            if approving {
                approveUserButton.showActivity()
            } else {
                approveUserButton.hideActivity()
            }
        }
        
        if approvingErrorMsg != state.adminUserDetailState.approvingErrorMsg {
            approvingErrorMsg = state.adminUserDetailState.approvingErrorMsg
            if !approvingErrorMsg.isEmpty {
                Alertift.alert(title: "An Error Occurred", message: approvingErrorMsg)
                    .action(.default("Ok"))
                    .show()
            }
        }
        
        if approveSuccess != state.adminUserDetailState.approveSuccess {
            approveSuccess = state.adminUserDetailState.approveSuccess
            if approveSuccess {
                Alertift.alert(title: "Success", message: "The user is now approved")
                    .action(.default("Ok"))
                    .show()
            }
        }
    }
    
}

extension AdminUsersDetailViewController : TextFieldHelperDelegate {
    
    func textFieldHelper(_ textField: UITextField, idleTimeout value: String) {
        userName = value
        nameTextField.resignFirstResponder()
        store.dispatch(SetAdminUserName(userName: value))
        if value.isEmpty {
            nameHelpText.text = "Name cannot be empty"
            nameHelper?.validContext = .invalid
        } else {
            store.dispatch(adminUserSaveName)
        }
    }
    
}
