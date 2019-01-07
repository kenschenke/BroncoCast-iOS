//
//  Broadcast.swift
//  BroncoCast
//
//  Created by Ken Schenke on 1/1/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import Foundation

struct Broadcast : Equatable {
    var sentBy : String
    var delivered : String
    var shortMsg : String
    var longMsg : String
    var recipients : [String]
}
