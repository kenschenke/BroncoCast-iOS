//
//  NavigationAction.swift
//  BroncoCast
//
//  Created by Ken Schenke on 12/26/18.
//  Copyright © 2018 Ken Schenke. All rights reserved.
//

import Foundation
import ReSwift

/**
 Root path is one of /checkauth, /auth, or /main
 
 Auth Paths
 /auth/signin
 /auth/forgot/step1
 /auth/forgot/step2
 /auth/register/step1
 /auth/register/step2
 
 If navigating to anything in /auth from NavigateToPath, just switch to to the
 SignInNavigationController and be done.
 
 Main Paths
 /main/profile/name
 /main/profile/contacts
 /main/profile/orgs
 /main/mybroadcasts
 /main/admin/users
 /main/admin/groups
 /main/admin/broadcasts
 
 UIViewController.navigationController is an optional that contains a reference to
 the containing UINavigationController.
 
 If navigating to /main/profile/??
    1) If not already in /main/??, switch to MainNavigationController
    2) If not already in /main/profile/??, switch tab to Profile tab
    3) If not already at correct path, switch segment control to correct index
 
 
 
 **/

enum BaseNavigationPath : String {
    case basepath_none = "none"
    case basepath_main = "main"
    case basepath_auth = "auth"
    case basepath_checkauth = "checkauth"
}

enum TabNavigationPath : String {
    case tab_none = "none"
    case tab_signin = "signin"
    case main_profile_tab = "profile"
    case main_mybroadcasts_tab = "mybroadcasts"
    case main_admin_tab = "admin"
}

enum SegmentNavigationPath : String {
    case segment_none = "none"
    case profile_name_segment = "name"
    case profile_contacts_segment = "contacts"
    case profile_orgs_segment = "orgs"
}

enum NavigationPath : String {
    case checkauth = "/checkauth"
    
    case auth_signin = "/auth/signin"
    
    case profile_name = "/main/profile/name"
    case profile_contacts = "/main/profile/contacts"
    case profile_orgs = "/main/profile/orgs"
}

func navigateTo(path : NavigationPath, withDetail : String = "") -> Action {
    var basePath : BaseNavigationPath
    var tabPath : TabNavigationPath = .tab_none
    var segmentPath : SegmentNavigationPath = .segment_none
    
    switch path {
    case .checkauth:
        basePath = .basepath_checkauth
        
    case .auth_signin:
        basePath = .basepath_auth
        
    case .profile_name:
        basePath = .basepath_main
        tabPath = .main_profile_tab
        segmentPath = .profile_name_segment
        
    case .profile_contacts:
        basePath = .basepath_main
        tabPath = .main_profile_tab
        segmentPath = .profile_contacts_segment
        
    case .profile_orgs:
        basePath = .basepath_main
        tabPath = .main_profile_tab
        segmentPath = .profile_orgs_segment
    }
    
    return NavigateToPath(base: basePath, tab: tabPath, segment: segmentPath, detail: withDetail)
}

struct NavigateToPath : Action {
    var base : BaseNavigationPath
    var tab : TabNavigationPath
    var segment : SegmentNavigationPath
    var detail : String
}

struct NavigateToPathStr : Action {
    var path : String
}
