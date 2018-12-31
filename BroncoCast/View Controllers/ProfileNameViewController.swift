//
//  ProfileNameViewController.swift
//  BroncoCast
//
//  Created by Ken Schenke on 12/31/18.
//  Copyright © 2018 Ken Schenke. All rights reserved.
//

import UIKit
import ReSwift

class ProfileNameViewController: UIViewController, StoreSubscriber {

    @IBOutlet weak var myLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        store.subscribe(self)
    }
    
    func newState(state: AppState) {
        if state.navigationState.dataRefreshNeeded &&
            state.navigationState.pathSegment == .profile_name_segment {
            refreshDate()
        }
    }
    
    func refreshDate() {
        print("refreshData()")
        
        let now = Date()
        let fmt = DateFormatter()
        fmt.dateStyle = .medium
        fmt.timeStyle = .medium
        
        myLabel.text = fmt.string(from: now)
        
        store.dispatch(clearDataRefreshNeeded())
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
