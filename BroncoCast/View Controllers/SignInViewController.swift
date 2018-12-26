//
//  SignInViewController.swift
//  BroncoCast
//
//  Created by Ken Schenke on 12/23/18.
//  Copyright © 2018 Ken Schenke. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @IBAction func showPasswordChanged(_ sender: Any) {
        passwordTextField.isSecureTextEntry.toggle()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if usernameTextField.isFirstResponder {
            passwordTextField.becomeFirstResponder()
        } else if passwordTextField.isFirstResponder {
            passwordTextField.resignFirstResponder()
        }
        
        return true
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        store.dispatch(NavigationToMainAction())
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
