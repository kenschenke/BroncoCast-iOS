//
//  SignInOptionsViewController.swift
//  BroncoCast
//
//  Created by Ken Schenke on 2/12/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import UIKit

class SignInOptionsViewController: UIViewController {
    
    @IBOutlet weak var serverTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        serverTextField.text = appSettings.serverAddr
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        appSettings.save(newServer: serverTextField.text!)
        _ = navigationController?.popViewController(animated: true)
    }
}
