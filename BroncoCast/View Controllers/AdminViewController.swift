//
//  AdminViewController.swift
//  BroncoCast
//
//  Created by Ken Schenke on 12/30/18.
//  Copyright © 2018 Ken Schenke. All rights reserved.
//

import UIKit

class AdminViewController: UIViewController {

    @IBOutlet weak var usersView: UIView!
    @IBOutlet weak var groupsView: UIView!
    @IBOutlet weak var broadcastsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        usersView.isHidden = false
        groupsView.isHidden = true
        broadcastsView.isHidden = true
        
        print("AdminViewController::viewDidLoad()")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("AdminViewController::viewWillAppear()")
    }
    
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            usersView.isHidden = false
            groupsView.isHidden = true
            broadcastsView.isHidden = true
            
        case 1:
            usersView.isHidden = true
            groupsView.isHidden = false
            broadcastsView.isHidden = true
            
        case 2:
            usersView.isHidden = true
            groupsView.isHidden = true
            broadcastsView.isHidden = false
            
        default:
            break
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
