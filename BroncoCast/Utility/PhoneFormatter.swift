//
//  PhoneFormatter.swift
//  BroncoCast
//
//  Created by Ken Schenke on 1/19/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import Foundation

func getPhoneNumberDigitsOnly(_ value: String) -> String {
    if value.isEmpty {
        return ""
    }
    
    let phoneRegex = try! NSRegularExpression(pattern: "[^0-9]")
    let range = NSRange(location: 0, length: value.utf16.count)
    return phoneRegex.stringByReplacingMatches(in: value, options: [], range: range, withTemplate: "")
}

func isPhoneNumber(_ str : String) -> Bool {
    let phoneRegex = try! NSRegularExpression(pattern: "[^0-9]")
    let range = NSRange(location: 0, length: str.utf16.count)
    return phoneRegex.firstMatch(in: str, options: [], range: range) == nil
}

func formatPhoneNumber(_ phone : String) -> String {
    let start = phone.index(phone.startIndex, offsetBy: 3)
    let end = phone.index(start, offsetBy: 2)

    return "(\(phone.prefix(3))) \(phone[start...end])-\(phone.suffix(4))"
}
