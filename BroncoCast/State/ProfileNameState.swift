//
//  ProfileNameState.swift
//  BroncoCast
//
//  Created by Ken Schenke on 12/31/18.
//  Copyright © 2018 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift

struct ProfileNameState : StateType {
    var getting = false
    var name = ""
    var singleMsg = false
    var updating = false
    var saved = false
    var errorMsg = ""
}
