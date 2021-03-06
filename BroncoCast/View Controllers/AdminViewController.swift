//
//  AdminViewController.swift
//  BroncoCast
//
//  Created by Ken Schenke on 12/30/18.
//  Copyright © 2018 Ken Schenke. All rights reserved.
//

import UIKit
import ReSwift
import SwiftyPickerPopover

class AdminViewController: UIViewController, StoreSubscriber {

    var viewHasAppeared = false
    var segmentPath : SegmentNavigationPath = .segment_none
    var adminOrgs : [AdminOrg] = []
    var adminOrgNames : [String] = []
    var adminOrgId = 0
    var adminOrgName = ""

    @IBOutlet weak var usersView: UIView!
    @IBOutlet weak var groupsView: UIView!
    @IBOutlet weak var broadcastsView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var adminOrgButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        usersView.isHidden = false
        groupsView.isHidden = true
        broadcastsView.isHidden = true

        store.subscribe(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewHasAppeared = true
        if segmentPath != .segment_none {
            switchSegment()
        }
    }
    
    func switchSegment() {
        var segment = segmentedControl.selectedSegmentIndex
        
        switch segmentPath {
        case .admin_users_segment:
            segment = 0
            self.navigationController?.navigationBar.topItem?.title = "Users"

        case .admin_groups_segment:
            segment = 1
            self.navigationController?.navigationBar.topItem?.title = "Groups"

        case .admin_broadcasts_segment:
            segment = 2
            self.navigationController?.navigationBar.topItem?.title = "Broadcasts"

        default:
            break
        }
        
        segmentedControl.selectedSegmentIndex = segment
        updateViewFromSegmentValue()
    }
    
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            store.dispatch(navigateTo(path: .admin_users))
            
        case 1:
            store.dispatch(navigateTo(path: .admin_groups))
            
        case 2:
            store.dispatch(navigateTo(path: .admin_broadcasts))

        default:
            break
        }
    }

    func updateViewFromSegmentValue() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            usersView.isHidden = false
            groupsView.isHidden = true
            broadcastsView.isHidden = true
            
        case 1:
            usersView.isHidden = true
            groupsView.isHidden = false
            broadcastsView.isHidden = true
            
        case 2:
            usersView.isHidden = true
            groupsView.isHidden = true
            broadcastsView.isHidden = false

        default:
            break
        }
    }

    @IBAction func adminOrgButtonPressed(_ sender: Any) {
        var adminOrgRow = 0
        var row = 0
        for org in adminOrgs {
            if org.OrgId == adminOrgId {
                adminOrgRow = row
            }
            row += 1
        }
        StringPickerPopover(title: "Select Admin Organization", choices: adminOrgNames)
            .setFontSize(17)
            .setSelectedRow(adminOrgRow)
            .setDoneButton(action: { (popover, selectedRow, selectedString) in
                store.dispatch(SetAdminOrg(
                    adminOrgId: self.adminOrgs[selectedRow].OrgId,
                    adminOrgName: self.adminOrgs[selectedRow].OrgName)
                )
            })
            .setCancelButton(action: { (_, _, _) in print("cancel")}
            )
            .appear(originView: adminOrgButton, baseViewController: self)
    }
    
    func newState(state: AppState) {
        if state.navigationState.pathSegment != segmentPath {
            segmentPath = state.navigationState.pathSegment
            if viewHasAppeared {
                switchSegment()
            }
        }

        if state.profileOrgsState.adminOrgs != adminOrgs {
            adminOrgs = state.profileOrgsState.adminOrgs
            adminOrgNames = adminOrgs.map { $0.OrgName }
        }
        
        if adminOrgId != state.adminOrgState.adminOrgId {
            adminOrgId = state.adminOrgState.adminOrgId
        }
        
        if adminOrgName != state.adminOrgState.adminOrgName {
            adminOrgName = state.adminOrgState.adminOrgName
            adminOrgButton.setTitle(adminOrgName, for: .normal)
        }
    }
}
