//
//  oginView.swift
//  PUC Clone
//
//  Created by Tomas Martins on 16/03/19.
//  Copyright © 2019 Tomas Martins. All rights reserved.
//

import UIKit

class LoginView: UIViewController {
    
    let pucController = PucController()
    var student: Student?
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var raTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.isEnabled = false
        loginButton.backgroundColor = UIColor.gray
        passwordTextfield.delegate = self
        raTextfield.delegate = self
    }
    @IBAction func loginButtonPressed(_ sender: Any) {
        self.performLoginSegue()
    }
    
    func performLoginSegue() {
        let user = raTextfield.text ?? ""
        let password = passwordTextfield.text ?? ""
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        pucController.getLoginToken(username: user, password: password)
        pucController.initialLogin(callback: {(student) -> Void in
            DispatchQueue.main.async {
                if student.message == nil {
                    UserDefaults.standard.set(user, forKey: "ra")
                    UserDefaults.standard.set(password, forKey: "senha")
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                    self.student = student
                    self.performSegue(withIdentifier: "today", sender: nil)
                } else {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                    let errorAlert = UIAlertController(title: "Credenciais erradas", message: "Verifique o seu RA e sua senha", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(errorAlert, animated: true, completion: nil)                }
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "today" {
            if let todayView = segue.destination as? StudentView {
                todayView.student = self.student
            }
        }
    }
    
}

extension LoginView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if loginButton.isEnabled {
            performLoginSegue()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (raTextfield.text?.isEmpty)! || (passwordTextfield.text?.isEmpty)! {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.gray
        } else {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor(red:0.15, green:0.44, blue:0.75, alpha:1.0)
        }
        return true
    }
}
