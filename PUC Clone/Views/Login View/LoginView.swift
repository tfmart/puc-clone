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
        self.performLoginSegue()
    }
    
    func performLoginSegue() {
        let user = raTextfield.text ?? ""
        let password = passwordTextfield.text ?? ""
        let pucConfig = PuccConfiguration(username: user, password: password)
        
        if let token = pucConfig.token {
            UserDefaults.standard.set(token, forKey: "login")
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        PuccService.shared.fetchSession(config: pucConfig) { (response) in
            DispatchQueue.main.async {
                switch response {
                case .success:
                    UserDefaults.standard.set(user, forKey: "ra")
                    UserDefaults.standard.set(password, forKey: "senha")
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                    self.performSegue(withIdentifier: "today", sender: nil)
                case .failure(.noData):
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                    let errorAlert = UIAlertController(title: "Erro", message: "Não foi possível realizar o seu login. Por favor, tente novamente", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(errorAlert, animated: true, completion: nil)
                case .failure(.apiError):
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                    let errorAlert = UIAlertController(title: "Credenciais erradas", message: "Verifique o seu RA e sua senha", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(errorAlert, animated: true, completion: nil)
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
