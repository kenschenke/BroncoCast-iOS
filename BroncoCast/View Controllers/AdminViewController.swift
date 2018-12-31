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
        usersView.alpha = 1.0
        groupsView.alpha = 0.0
        broadcastsView.alpha = 0.0
    }
    
    @IBAction func segmentValueChanged(_ sender: Any) {
        if let segmentedControl = sender as? UISegmentedControl {
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                usersView.alpha = 1.0
                groupsView.alpha = 0.0
                broadcastsView.alpha = 0.0
                
            case 1:
                usersView.alpha = 0.0
                groupsView.alpha = 1.0
                broadcastsView.alpha = 0.0
                
            case 2:
                usersView.alpha = 0.0
                groupsView.alpha = 0.0
                broadcastsView.alpha = 1.0
                
            default:
                break
            }
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
