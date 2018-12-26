//
//  NavigationState.swift
//  BroncoCast
//
//  Created by Ken Schenke on 12/26/18.
//  Copyright © 2018 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift

enum Screen {
    case signIn
    case main
}

struct NavigationState : StateType {
    var screen: Screen = .signIn
}
