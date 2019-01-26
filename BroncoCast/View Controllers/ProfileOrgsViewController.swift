//
//  ProfileOrgsViewController.swift
//  BroncoCast
//
//  Created by Ken Schenke on 1/21/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import UIKit
import ReSwift
import Alertift

class ProfileOrgsViewController: UIViewController, StoreSubscriber,
    UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var userOrgs : [UserOrg] = []
    var fetching = false
    var fetchingErrorMsg = ""
    var joining = false
    var joiningErrorMsg = ""
    var joinTag = ""
    var dropMemberId = 0
    var dropping = false
    var droppingErrorMsg = ""
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var joinOrgTextField: UITextField!
    @IBOutlet weak var joinButton: ActivityButton!
    @IBOutlet weak var joinButtonBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        store.subscribe(self)
        
        joinButton.activityLabel = "Joining"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        joinOrgTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        joinOrgTextField.delegate = self
    }
    
    func newState(state: AppState) {
        if state.profileOrgsState.userOrgs != userOrgs {
            userOrgs = state.profileOrgsState.userOrgs
            tableView.reloadData()
        }
        
        if state.profileOrgsState.userOrgsFetching != fetching {
            fetching = state.profileOrgsState.userOrgsFetching
            tableView.reloadData()
        }
        
        if state.profileOrgsState.userOrgsErrorMsg != fetchingErrorMsg {
            fetchingErrorMsg = state.profileOrgsState.userOrgsErrorMsg
            tableView.reloadData()
        }

        if state.navigationState.dataRefreshNeeded &&
            state.navigationState.pathSegment == .profile_orgs_segment {
            
            store.dispatch(clearDataRefreshNeeded())
            store.dispatch(getUserOrgs)
        }
        
        if state.profileOrgsState.joining != joining {
            joining = state.profileOrgsState.joining
            if joining {
                joinButton.showActivity()
            } else {
                joinButton.hideActivity()
            }
        }
        
        if state.profileOrgsState.joiningErrorMsg != joiningErrorMsg {
            joiningErrorMsg = state.profileOrgsState.joiningErrorMsg
            if !joiningErrorMsg.isEmpty {
                Alertift.alert(title: "An Error Occurred", message: joiningErrorMsg)
                    .action(.default("Ok"))
                    .show()
            }
        }
        
        if state.profileOrgsState.joinTag != joinTag {
            joinTag = state.profileOrgsState.joinTag
            joinOrgTextField.text = joinTag
        }
        
        if state.profileOrgsState.dropMemberId != dropMemberId {
            dropMemberId = state.profileOrgsState.dropMemberId
            tableView.reloadData()
        }
        
        if state.profileOrgsState.dropping != dropping {
            dropping = state.profileOrgsState.dropping
            tableView.reloadData()
        }
        
        if state.profileOrgsState.droppingErrorMsg != droppingErrorMsg {
            droppingErrorMsg = state.profileOrgsState.droppingErrorMsg
            if !droppingErrorMsg.isEmpty {
                Alertift.alert(title: "An Error Occurred", message: droppingErrorMsg)
                    .action(.default("Ok"))
                    .show()
            }
        }
    }
    
    @IBAction func joinButtonPressed(_ sender: Any) {
        joinUserOrg()
    }
    
    @objc func textFieldChanged() {
        store.dispatch(SetJoinTag(joinTag: joinOrgTextField.text!))
    }
    
    func joinUserOrg() {
        let tag = joinTag.trimmingCharacters(in: .whitespacesAndNewlines)
        if tag.isEmpty {
            Alertift.alert(title: "An Error Occurred", message: "Tag cannot be empty")
                .action(.default("Ok"))
                .show()
            return
        }
        joinOrgTextField.resignFirstResponder()
        store.dispatch(joinOrg)
    }
    
    // MARK: - TableView Datasource methods

    func numberOfSections(in tableView: UITableView) -> Int {
        // Section 1 - organizations
        // Section 2 - fetching message
        // Section 3 - error message
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return userOrgs.count
        } else if section == 1 {
            return fetching ? 1 : 0
        } else if section == 2 {
            return fetchingErrorMsg.isEmpty ? 0 : 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if dropping && dropMemberId == userOrgs[indexPath.row].MemberId {
                return tableView.dequeueReusableCell(withIdentifier: "ProfileOrgDroppingOrg", for: indexPath)
            }
            
            let cell =  tableView.dequeueReusableCell(withIdentifier: "ProfileOrgCell", for: indexPath)
                as! ProfileOrgTableViewCell
            cell.orgNameLabel?.text = "\(userOrgs[indexPath.row].OrgName)\(userOrgs[indexPath.row].IsAdmin ? " (Admin)" : "")"
            cell.memberId = userOrgs[indexPath.row].MemberId
            return cell
        } else if indexPath.section == 1 {
            return tableView.dequeueReusableCell(withIdentifier: "ProfileOrgFetchingCell", for: indexPath)
        } else if indexPath.section == 2 {
            let cell =  tableView.dequeueReusableCell(withIdentifier: "ProfileOrgErrorMsgCell", for: indexPath) as! ProfileOrgsErrorMsgTableViewCell
            cell.errorMsgLabel.text = fetchingErrorMsg
            return cell
        }
        
        return tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 44;
        } else if indexPath.section == 1 {
            return fetching ? 32 : 0
        } else if indexPath.section == 2 {
            return fetchingErrorMsg.isEmpty ? 0 : 32
        }
        
        return 0
    }
    
    // MARK: - UITextFieldDelegate Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.joinButtonBottomConstraint.constant = 180
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        joinUserOrg()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.joinButtonBottomConstraint.constant = 20
            self.view.layoutIfNeeded()
        }
    }
}
