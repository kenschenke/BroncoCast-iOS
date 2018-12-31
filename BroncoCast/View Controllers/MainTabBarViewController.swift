//
//  MainTabBarViewController.swift
//  BroncoCast
//
//  Created by Ken Schenke on 12/30/18.
//  Copyright © 2018 Ken Schenke. All rights reserved.
//

import UIKit
import ReSwift

class MainTabBarViewController: UITabBarController, StoreSubscriber {
    
    var notAdmin = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        store.subscribe(self)
        
        print("MainTabBarViewController::viewDidLoad()")
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
        if state.profileOrgsState.notAdmin != notAdmin {
            notAdmin = state.profileOrgsState.notAdmin
            if notAdmin {
                viewControllers?.remove(at: 2)
            }
        }
    }
    
    @IBAction func signOutPressed(_ sender: UIBarButtonItem) {
        store.dispatch(logout)
    }
}
