//
//  AdminGroupDetailViewController.swift
//  BroncoCast
//
//  Created by Ken Schenke on 2/4/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import UIKit
import ReSwift
import Alertift

class AdminGroupDetailViewController: UIViewController, StoreSubscriber {
    
    var members : [GroupMember] = []
    var fetching = false
    var fetchingErrorMsg = ""
    var deleting = false
    var deletingErrorMsg = ""
    var goBack = false

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deleteButton: ActivityButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        store.subscribe(self)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        deleteButton.activityLabel = "Deleting"
    }
    
    func newState(state: AppState) {
        if members != state.adminGroupDetailState.members {
            members = state.adminGroupDetailState.members
            tableView.reloadData()
        }
        
        if fetching != state.adminGroupDetailState.fetching {
            fetching = state.adminGroupDetailState.fetching
            tableView.reloadData()
        }
        
        if fetchingErrorMsg != state.adminGroupDetailState.fetchingErrorMsg {
            fetchingErrorMsg = state.adminGroupDetailState.fetchingErrorMsg
            tableView.reloadData()
        }
        
        if deleting != state.adminGroupDetailState.deleting {
            deleting = state.adminGroupDetailState.deleting
            if deleting {
                deleteButton.showActivity()
            } else {
                deleteButton.hideActivity()
            }
        }
        
        if deletingErrorMsg != state.adminGroupDetailState.deletingErrorMsg {
            deletingErrorMsg = state.adminGroupDetailState.deletingErrorMsg
            if !deletingErrorMsg.isEmpty {
                Alertift.alert(title: "An Error Occurred", message: deletingErrorMsg)
                    .action(.default("Ok"))
                    .show()
            }
        }
        
        if goBack != state.adminGroupDetailState.goBack {
            goBack = state.adminGroupDetailState.goBack
            if goBack {
                _ = navigationController?.popViewController(animated: true)
            }
        }
    }

    @IBAction func deleteGroupPressed(_ sender: Any) {
        Alertift.alert(title: "Confirm", message: "Delete group?")
            .action(.destructive("Delete")) { _, _, _ in
                store.dispatch(adminDeleteGroup)
            }
            .action(.cancel("Cancel"))
            .show()
    }
}

extension AdminGroupDetailViewController : UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 64
        }
        
        return 44
    }
    
    // Sections:
    //    0 - members
    //    1 - fetching message
    //    2 - empty table
    //    3 - error message
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return members.count
        } else if section == 1 && fetching {
            return 1
        } else if section == 2 && members.isEmpty && !fetching && fetchingErrorMsg.isEmpty {
            return 1
        } else if section == 3 && !fetchingErrorMsg.isEmpty {
            return 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AdminGroupDetailCell",
                                                     for: indexPath) as! AdminGroupDetailTableViewCell
            
            cell.memberNameCell.text = members[indexPath.row].MemberName
            return cell
        } else if indexPath.section == 1 {
            return tableView.dequeueReusableCell(withIdentifier: "AdminGroupDetailFetchingCell", for: indexPath)
        } else if indexPath.section == 2 {
            return tableView.dequeueReusableCell(withIdentifier: "AdminGroupDetailEmptyCell", for: indexPath)
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AdminGroupDetailErrorMsgCell", for: indexPath) as! AdminGroupDetailErrorMsgTableViewCell
            cell.errorMsgLabel.text = fetchingErrorMsg
            return cell
        }
        
        return tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
    }
    
    
}
