//
//  NavigationReducer.swift
//  BroncoCast
//
//  Created by Ken Schenke on 12/26/18.
//  Copyright © 2018 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift

func navigationReducer(_ action: Action, state: NavigationState?) -> NavigationState {
    var newState = state ?? NavigationState()
    
    if let navigateToPath = action as? NavigateToPath {
        newState.pathBase = navigateToPath.base
        newState.pathTab = navigateToPath.tab
        newState.pathSegment = navigateToPath.segment
        newState.pathDetail = navigateToPath.detail
        
        let currentBase = state?.pathBase
        let newBase = navigateToPath.base

        if currentBase != newBase {
            var navIdentifier : String
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            switch newBase {
            case .basepath_checkauth:
                navIdentifier = "CheckAuthScreen"
                
            case .basepath_main:
                navIdentifier = "MainNavigationController"
                
            case .basepath_auth:
                navIdentifier = "SignInNavigationController"
                
            default:
                return newState
            }
            let nav = appDelegate.storyboard.instantiateViewController(withIdentifier: navIdentifier)
            appDelegate.window?.rootViewController = nav
        }
    }
    
    return newState
}
