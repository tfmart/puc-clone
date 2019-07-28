//
//  oginView.swift
//  PUC Clone
//
//  Created by Tomas Martins on 16/03/19.
//  Copyright © 2019 Tomas Martins. All rights reserved.
//

import UIKit
import PuccSwift

class LoginView: UIViewController {
    
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
        self.loginButtonAction()
    }
    
    fileprivate func performLogin(username: String, password: String) {
        UserDefaults.standard.set(username, forKey: "ra")
        UserDefaults.standard.set(password, forKey: "senha")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.performSegue(withIdentifier: "today", sender: nil)
    }
    
    fileprivate func showErrorAlert(error: APIServiceError) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let errorAlert = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(errorAlert, animated: true, completion: nil)
    }
    
    func loginButtonAction() {
        guard let username = raTextfield.text, let password = passwordTextfield.text else {
            let errorAlert = UIAlertController(title: "Erro", message: "Por favor, preencha ambos os campos", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(errorAlert, animated: true, completion: nil)
            return
        }
        let pucConfig = PuccConfiguration(username: username, password: password)
        
        if let token = pucConfig.token {
            UserDefaults.standard.set(token, forKey: "login")
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        PuccService.shared.fetchSession(config: pucConfig) { (response) in
            DispatchQueue.main.async {
                switch response {
                case .success:
                    self.performLogin(username: username, password: password)
                case .failure(.noData):
                    self.showErrorAlert(error: .noData)
                case .failure(.apiError):
                    self.showErrorAlert(error: .apiError)
                default:
                    print("Error: \(response)")
                }
            }
        }
    }
}

extension LoginView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if loginButton.isEnabled {
            loginButtonAction()
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
