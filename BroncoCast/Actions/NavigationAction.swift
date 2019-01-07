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
 This enum is the primary means of navigating to any
 screen in the app.
 */

enum NavigationPath {
    case checkauth
    
    case auth_signin
    
    case profile_name
    case profile_contacts
    case profile_orgs
    
    case mybroadcasts
    
    case admin_users
    case admin_groups
    case admin_broadcasts
}

/**
 This enum represents the top level of navigation
 */

enum BaseNavigationPath {
    case basepath_none
    case basepath_main
    case basepath_auth
    case basepath_checkauth
}

/**
 This enum represents the middle level of navigation
 */

enum TabNavigationPath {
    case tab_none
    case tab_signin
    case main_profile_tab
    case main_mybroadcasts_tab
    case main_admin_tab
}

/**
 This enum represents the lowest level of nativation
 */

enum SegmentNavigationPath {
    case segment_none
    case profile_name_segment
    case profile_contacts_segment
    case profile_orgs_segment
    case admin_users_segment
    case admin_groups_segment
    case admin_broadcasts_segment
}

/**
 This action creator is the primary means to navigate to
 any screen in the app.
 */

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
        
    case .mybroadcasts:
        basePath = .basepath_main
        tabPath = .main_mybroadcasts_tab
        segmentPath = .segment_none
        
    case .admin_users:
        basePath = .basepath_main
        tabPath = .main_admin_tab
        segmentPath = .admin_users_segment
        
    case .admin_groups:
        basePath = .basepath_main
        tabPath = .main_admin_tab
        segmentPath = .admin_groups_segment
        
    case .admin_broadcasts:
        basePath = .basepath_main
        tabPath = .main_admin_tab
        segmentPath = .admin_broadcasts_segment
    }
    
    return NavigateToPath(base: basePath, tab: tabPath, segment: segmentPath, detail: withDetail)
}

/**
 This is the action passed into the navigation reducer
 */

struct NavigateToPath : Action {
    var base : BaseNavigationPath
    var tab : TabNavigationPath
    var segment : SegmentNavigationPath
    var detail : String
}

struct setDataRefreshNeeded : Action {
}

struct clearDataRefreshNeeded : Action {
}

