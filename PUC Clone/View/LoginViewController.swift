//
//  ViewController.swift
//  PUC Clone
//
//  Created by Tomas Martins on 24/01/19.
//  Copyright © 2019 Tomas Martins. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    let studentModel = StudentModel()
    @IBOutlet weak var raTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.raTextfield.delegate = self
        self.passwordTextfield.delegate = self
        self.loginButton.isEnabled = false
    }

    @IBAction func loginButtonPressed(_ sender: Any) {
        self.performLoginSegue()
    }
    
    func performLoginSegue() {
        let user = raTextfield.text ?? ""
        let password = passwordTextfield.text ?? ""
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        studentModel.getStudent(username: user, password: password, callback: {(student) -> Void in
            DispatchQueue.main.async {
                if student.nome != nil {
                    self.performSegue(withIdentifier: "loginSuccessful", sender: nil)
                } else {
                    let errorAlert = UIAlertController(title: "Credenciais erradas", message: "Verifique o seu RA e sua senha", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(errorAlert, animated: true, completion: nil)
                }
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        })
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if loginButton.isEnabled {
            performLoginSegue()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (raTextfield.text?.isEmpty)! || (passwordTextfield.text?.isEmpty)! {
            loginButton.isEnabled = false
        } else {
            loginButton.isEnabled = true
        }
        return true
    }
}
