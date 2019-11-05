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
    
    var configuration: PucConfiguration?
    
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
    
    fileprivate func performLogin(using configuration: PucConfiguration) {
        UserDefaults.standard.set(configuration.username, forKey: "ra")
        UserDefaults.standard.set(configuration.password, forKey: "senha")
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            self.performSegue(withIdentifier: "today", sender: nil)
        }
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
        self.configuration = PucConfiguration(username: username, password: password)
        
        if let token = self.configuration?.pucToken {
            UserDefaults.standard.set(token, forKey: "login")
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let request = LoginRequester(configuration: self.configuration!) { (student, error) in
            guard student != nil else {
                if let requestError = error {
                    self.showErrorAlert(error: requestError)
                } else {
                    self.showErrorAlert(error: .noData)
                }
                return
            }
            self.performLogin(using: self.configuration!)
        }
        request.start()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "today" {
            if let navigationView = segue.destination as? UINavigationController {
                let todayView = navigationView.topViewController as? TodayView
                todayView!.configuration = self.configuration
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
