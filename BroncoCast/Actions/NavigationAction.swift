//
//  NavigationAction.swift
//  BroncoCast
//
//  Created by Ken Schenke on 12/26/18.
//  Copyright © 2018 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift

struct NavigateToSignInAction: Action {
}

struct NavigationToMainAction: Action {
}

/*
public enum Screen {
    case signIn
    case register
    case userProfile
}

public struct NavigationState: StateType {
    var transition: Bool
    var transitionData: [AnyHashable: Any]
    var newScreen: Screen?
    var newScreenHierarchy: [Screen]
    var deepLink: Bool
    var transitionInProgress: Bool
}

public enum NavigationAction: Action {
    case transition(screen: Screen, data: [AnyHashable: Any])
}
*/

