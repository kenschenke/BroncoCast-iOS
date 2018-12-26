//
//  MainViewController.swift
//  BroncoCast
//
//  Created by Ken Schenke on 12/24/18.
//  Copyright © 2018 Ken Schenke. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func signOutPressed(_ sender: Any) {
        store.dispatch(NavigateToSignInAction())
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
