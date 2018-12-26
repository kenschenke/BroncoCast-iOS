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
    
    var navIdentifier : String
    var navScreen : Screen
    
    if action is NavigateToSignInAction {
        navScreen = .signIn
        navIdentifier = "SignInNavigationController"
    } else if action is NavigationToMainAction {
        navScreen = .main
        navIdentifier = "MainNavigationController"
    } else {
        return newState
    }

    newState.screen = navScreen
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let nav = appDelegate.storyboard.instantiateViewController(withIdentifier: navIdentifier)
    appDelegate.window?.rootViewController = nav

    return newState
}
