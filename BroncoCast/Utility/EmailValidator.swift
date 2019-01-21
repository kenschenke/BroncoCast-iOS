//
//  EmailValidator.swift
//  BroncoCast
//
//  Created by Ken Schenke on 1/19/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import Foundation

func isEmailAddressValid(_ email : String) -> Bool {
    let emailRegex = try! NSRegularExpression(pattern:
        "\\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}\\b")
    let range = NSRange(location: 0, length: email.utf16.count)
    return emailRegex.firstMatch(in: email, options: [], range: range) != nil
}
