//
//  SignInOptionsViewController.swift
//  BroncoCast
//
//  Created by Ken Schenke on 2/12/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import UIKit

class SignInOptionsViewController: UIViewController {
    
    var serverHelper : TextFieldHelper?

    @IBOutlet weak var serverTextField: UITextField!
    @IBOutlet weak var helpTextField: UILabel!
    @IBOutlet weak var serverLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        serverTextField.text = appSettings.serverAddr
        serverHelper = TextFieldHelper(serverTextField)
        serverHelper?.delegate = self
        serverHelper?.helpTextLabel = helpTextField
        serverHelper?.label = serverLabel
        
        helpTextField.text = ""
    }
    
    func isServerNameValid() -> Bool {
        let server = serverTextField.text!
        return server.prefix(7) == "http://" || server.prefix(8) == "https://"
    }
    
    func validateServer() {
        if !isServerNameValid() {
            helpTextField.text = "Must start with http:// or https://"
            serverHelper?.validContext = .invalid
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        validateServer()
        if isServerNameValid() {
            appSettings.save(newServer: serverTextField.text!)
            _ = navigationController?.popViewController(animated: true)
        }
    }
}

extension SignInOptionsViewController: TextFieldHelperDelegate {
    
    func textFieldHelper(_ textField: UITextField, idleTimeout value: String) {
        validateServer()
    }
    
    
}
