//
//  ProfileContactsViewController.swift
//  BroncoCast
//
//  Created by Ken Schenke on 1/8/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import UIKit
import ReSwift

class ProfileContactsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, StoreSubscriber {
    
    var contacts : [Contact] = []
    var fetching = false
    var errorMsg = ""
    var goBack = false
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        store.subscribe(self)
    }
    
    // MARK: - TableView Datasource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Section 1 - contacts
        // Section 2 - add buttons
        // Section 3 - single message switch
        // Section 4 - fetching message
        // Section 5 - error message
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if fetching {
            return section == 3 ? 1 : 0
        } else if !errorMsg.isEmpty {
            return section == 4 ? 1 : 0
        } else if section == 3 {
            return 0
        }
        
        return section == 0 ? contacts.count : 1
    }
    
    // MARK: - TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let contactCell = tableView.dequeueReusableCell(withIdentifier: "ProfileContactsTableViewCell", for: indexPath)
                as! ProfileContactsTableViewCell

            var contact = contacts[indexPath.row].contact
            if isPhoneNumber(contact) {
                contact = formatPhoneNumber(contact)
            }
            contactCell.contactLabel.text = contact
            return contactCell
        }
        else if indexPath.section == 1 {
            return tableView.dequeueReusableCell(withIdentifier: "ProfileAddContactCell", for: indexPath)
        } else if indexPath.section == 2 {
            return tableView.dequeueReusableCell(withIdentifier: "ProfileSingleMsgCell", for: indexPath)
        } else if indexPath.section == 3 {
            return tableView.dequeueReusableCell(withIdentifier: "ProfileContactsFetching", for: indexPath)
        } else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileContactsErrorMsg", for: indexPath) as! ProfileContactErrorMsgCell
            cell.errorMsg.text = errorMsg
            return cell
        } else {
            return tableView.dequeueReusableCell(withIdentifier: "ProfileContactsTableViewCell", for: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 65
        }
        else if indexPath.section == 1 {
            return 50
        }
        else if indexPath.section == 2 {
            return 142
        }
        else if indexPath.section == 3 || indexPath.section == 4 {
            return 32
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 32
        }

        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 50
        }

        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 && !fetching && errorMsg.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileContactsHeader")

            return cell?.contentView
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 && !fetching && errorMsg.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileAddContactFooter")

            return cell?.contentView
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        store.dispatch(SetProfileContactsNavBack(goBack: false))
        store.dispatch(SetProfileContactTestSent(testSent: false))
        store.dispatch(SetProfileContactToEdit(contactId: contacts[indexPath.row].contactId,
                                               contactName: contacts[indexPath.row].contact))
        
        let contact = contacts[indexPath.row].contact
        performSegue(withIdentifier: isPhoneNumber(contact) ?
            "showProfilePhoneContactDetail" :
            "showProfileEmailContactDetail", sender: self)
    }

    func newState(state: AppState) {
        if state.profileContactsState.contacts != contacts {
            contacts = state.profileContactsState.contacts
            tableView.reloadData()
        }
        
        if state.profileContactsState.fetching != fetching {
            fetching = state.profileContactsState.fetching
            tableView.reloadData()
        }
        
        if state.profileContactsState.errorMsg != errorMsg {
            errorMsg = state.profileContactsState.errorMsg
            tableView.reloadData()
        }

        if state.navigationState.dataRefreshNeeded &&
            state.navigationState.pathSegment == .profile_contacts_segment {
            
            store.dispatch(clearDataRefreshNeeded())
            store.dispatch(getProfileContacts)
        }
        
        if state.profileContactsEditState.goBack != goBack {
            goBack = state.profileContactsEditState.goBack
            if goBack {
                tableView.reloadData()
            }
        }
    }
    
    @IBAction func addEmailButtonPressed(_ sender: Any) {
        store.dispatch(SetProfileContactToEdit(contactId: 0, contactName: ""))
        store.dispatch(SetProfileContactsNavBack(goBack: false))
        performSegue(withIdentifier: "showProfileEmailContactDetail", sender: self)
    }
    
    @IBAction func addPhoneButtonPressed(_ sender: Any) {
        store.dispatch(SetProfileContactToEdit(contactId: 0, contactName: ""))
        store.dispatch(SetProfileContactsNavBack(goBack: false))
        performSegue(withIdentifier: "showProfilePhoneContactDetail", sender: self)
    }
}
