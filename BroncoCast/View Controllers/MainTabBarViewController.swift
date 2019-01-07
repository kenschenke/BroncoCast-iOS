//
//  MainTabBarViewController.swift
//  BroncoCast
//
//  Created by Ken Schenke on 12/30/18.
//  Copyright © 2018 Ken Schenke. All rights reserved.
//

import UIKit
import ReSwift

class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate, StoreSubscriber {
    
    var notAdmin = false
    var navigationTab : TabNavigationPath = .tab_none

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        store.subscribe(self)
        delegate = self
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
        
        if state.navigationState.pathTab != navigationTab {
            navigationTab = state.navigationState.pathTab
            switch navigationTab {
            case .main_profile_tab:
                selectedIndex = 0
                
            case .main_mybroadcasts_tab:
                selectedIndex = 1
                
            case .main_admin_tab:
                selectedIndex = 2
                
            case .tab_signin:
                break
                
            case .tab_none:
                break
            }
        }
    }
    
    @IBAction func signOutPressed(_ sender: UIBarButtonItem) {
        store.dispatch(logout)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        switch selectedIndex {
        case 0:  // Profile
            store.dispatch(navigateTo(path: .profile_name))
            
        case 1:
            store.dispatch(navigateTo(path: .mybroadcasts))
            
        case 2:
            store.dispatch(navigateTo(path: .admin_users))
            
        default:
            break
        }
    }
}
