//
//  UrlMaker.swift
//  BroncoCast
//
//  Created by Ken Schenke on 12/30/18.
//  Copyright © 2018 Ken Schenke. All rights reserved.
//

import Foundation

struct UrlMaker {
    enum UrlConstant : String {
        case is_auth = "auth/isauth"
        case sign_in = "auth/login"
        case logout = "logout?applogout"
        
        case profile = "api/profile"
        
        case user_broadcasts = "api/broadcasts"
        
        case profile_contacts = "api/contacts"
        
        case user_orgs = "api/orgs"
        
        case admin_users = "api/admin/users"
        case admin_users_hide = "api/admin/users/hide"
        case admin_users_unhide = "api/admin/users/unhide"
        case admin_users_admin = "api/admin/users/admin"
        case admin_users_name = "api/admin/users/name"
        case admin_users_remove = "api/admin/users/remove"
        case admin_users_approve = "api/admin/users/approve"
        
        case admin_groups = "api/admin/groups"
        case admin_groups_rename = "api/admin/groups/name"
        case admin_groups_remove = "api/admin/groups/remove"
        
        case admin_group_members = "api/admin/groups/members"
        case admin_group_nonmembers = "api/admin/groups/nonmembers"
        
        case admin_broadcasts = "api/admin/broadcasts"
        case admin_broadcasts_groups = "api/admin/broadcasts/groups"
        case admin_broadcasts_new = "api/admin/broadcasts/new"
    }
    
    static func makeUrl(_ url : UrlConstant) -> String {
        return "http://dev.broncocast.org/\(url.rawValue)"
    }
}
