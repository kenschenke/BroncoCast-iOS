//
//  MainViewController.swift
//  BroncoCast
//
//  Created by Ken Schenke on 12/24/18.
//  Copyright © 2018 Ken Schenke. All rights reserved.
//

import UIKit
import ReSwift

class ProfileViewController: UIViewController, StoreSubscriber {

    var viewHasAppeared = false
    var segmentPath : SegmentNavigationPath = .segment_none
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var contactInfoView: UIView!
    @IBOutlet weak var organizationsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameView.isHidden = false
        contactInfoView.isHidden = true
        organizationsView.isHidden = true
        
        store.subscribe(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewHasAppeared = true
        if segmentPath != .segment_none {
            switchSegment()
        }
    }
    
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            store.dispatch(navigateTo(path: .profile_name))
            
        case 1:
            store.dispatch(navigateTo(path: .profile_contacts))

        case 2:
            store.dispatch(navigateTo(path: .profile_orgs))

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

    func switchSegment() {
        var segment = segmentedControl.selectedSegmentIndex
        
        switch segmentPath {
        case .profile_name_segment:
            segment = 0
            
        case .profile_contacts_segment:
            segment = 1
            
        case .profile_orgs_segment:
            segment = 2
            
        default:
            break
        }
        
        segmentedControl.selectedSegmentIndex = segment
        updateViewFromSegmentValue()
    }
    
    func updateViewFromSegmentValue() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            nameView.isHidden = false
            contactInfoView.isHidden = true
            organizationsView.isHidden = true
            
        case 1:
            nameView.isHidden = true
            contactInfoView.isHidden = false
            organizationsView.isHidden = true
            
        case 2:
            nameView.isHidden = true
            contactInfoView.isHidden = true
            organizationsView.isHidden = false
            
        default:
            break
        }
    }
    
    func newState(state: AppState) {
        if state.navigationState.pathSegment != segmentPath {
            segmentPath = state.navigationState.pathSegment
            if viewHasAppeared {
                switchSegment()
            }
        }
    }
}
