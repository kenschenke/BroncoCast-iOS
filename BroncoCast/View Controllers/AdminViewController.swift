//
//  AdminViewController.swift
//  BroncoCast
//
//  Created by Ken Schenke on 12/30/18.
//  Copyright © 2018 Ken Schenke. All rights reserved.
//

import UIKit
import ReSwift

class AdminViewController: UIViewController, StoreSubscriber {

    var viewHasAppeared = false
    var segmentPath : SegmentNavigationPath = .segment_none
    
    @IBOutlet weak var usersView: UIView!
    @IBOutlet weak var groupsView: UIView!
    @IBOutlet weak var broadcastsView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
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
            
        case .admin_groups_segment:
            segment = 1
            
        case .admin_broadcasts_segment:
            segment = 2
            
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func newState(state: AppState) {
        if state.navigationState.pathSegment != segmentPath {
            segmentPath = state.navigationState.pathSegment
            if viewHasAppeared {
                switchSegment()
            }
        }
    }
}
