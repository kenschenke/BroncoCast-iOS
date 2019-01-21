//
//  ProfileContactsState.swift
//  BroncoCast
//
//  Created by Ken Schenke on 1/19/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift

struct ProfileContactsState : StateType {
    var fetching = false
    var errorMsg = ""
    var contacts : [Contact] = []
}
