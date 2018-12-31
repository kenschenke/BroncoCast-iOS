//
//  MainViewController.swift
//  BroncoCast
//
//  Created by Ken Schenke on 12/24/18.
//  Copyright © 2018 Ken Schenke. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var contactInfoView: UIView!
    @IBOutlet weak var organizationsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameView.alpha = 1.0
        contactInfoView.alpha = 0.0
        organizationsView.alpha = 0.0
    }
    

    @IBAction func signOutPressed(_ sender: Any) {
        store.dispatch(NavigateToSignInAction())
    }
    
    @IBAction func segmentValueChanged(_ sender: Any) {
        if let segmentedControl = sender as? UISegmentedControl {
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                nameView.alpha = 1.0
                contactInfoView.alpha = 0.0
                organizationsView.alpha = 0.0
                
            case 1:
                nameView.alpha = 0.0
                contactInfoView.alpha = 1.0
                organizationsView.alpha = 0.0
                
            case 2:
                nameView.alpha = 0.0
                contactInfoView.alpha = 0.0
                organizationsView.alpha = 1.0
                
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
