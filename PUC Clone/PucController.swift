//
//  PucController.swift
//  PUC Clone
//
//  Created by Tomas Martins on 24/01/19.
//  Copyright © 2019 Tomas Martins. All rights reserved.
//

import Foundation
import UIKit

class PucController {
    
    //MARK: Authentication on PUC's API
    
    func getLoginToken(username: String, password: String) {
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        UserDefaults.standard.set(base64LoginString, forKey: "login")
    }
    
    func initialLogin(callback: @escaping ((_ student: Student) -> Void)) {
        guard let authInfo = UserDefaults.standard.string(forKey: "login") else {
            return
        }
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        if let url = URL(string: "https://gateway-publico.pucapi.puc-campinas.edu.br/mobile/v3/usuarios/login") {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Basic \(authInfo)", forHTTPHeaderField: "Authorization")
            let task = session.dataTask(with: request) { (data, response, error) in
                if error == nil {
                    guard let data = data else {
                        return
                    }
                    do {
                        let student = try JSONDecoder().decode(Student.self, from: data)
                        callback(student)
                    } catch let jsonError {
                        print(jsonError)
                        return
                    }
                } else {
                    print("Error = \(String(describing: error))")
                    return
                }
            }
            task.resume()
        } else {
            print("Failed to parse URL")
        }
    }
    
    //MARK: Authentication on AVA"s API
    
    func getSakaiSessionToken(callback: @escaping ((_ token: String) -> Void)) {
        guard let username = UserDefaults.standard.string(forKey: "ra") else {
            return
        }
        guard let password = UserDefaults.standard.string(forKey: "senha") else {
            return
        }
        let endpoint = "http://ead.puc-campinas.edu.br/direct/session/new?_username=\(username)&_password=\(password)"
        UserDefaults.standard.removeObject(forKey: "ra")
        UserDefaults.standard.removeObject(forKey: "senha")
        if let url = URL(string: endpoint) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                guard error == nil else {
                    print(error!)
                    return
                }
                if let responseToken = String(data: data!, encoding: String.Encoding.utf8) {
                    //UserDefaults.standard.set(responseToken, forKey: "sakai")
                    callback(responseToken)
                }
            }
            task.resume()
        }
    }
    
    //MARK: Get Site titles from AVA
    
    func getAvaTitles(callback: @escaping ((_ titles: AvaSite) -> Void)) {
        guard let token = UserDefaults.standard.string(forKey: "sakai") else {
            return
        }
        let endpoint = "http://ead.puc-campinas.edu.br/direct/site.json?sakai.session=\(token)"
        print(endpoint)
        if let url = URL(string: endpoint) {
            URLSession.shared.dataTask(with: URLRequest(url: url), completionHandler: { (data, response, error) in
                if error != nil {
                    print("Error = \(String(describing: error))")
                    return
                }
                guard let data = data else {
                    return
                }
                do {
                    guard let sites  = try? JSONDecoder().decode(AvaSite.self, from: data) else {
                        return
                    }
                    callback(sites)
                }
            }).resume()
        } else {
            //URL is invalid
        }
    }
    
    //MARK: Get weekly schedule and completed subjects
    func getTakenClasses(callback: @escaping((_ subjects: [CompletedSubjects]) -> Void)) {
        let endpoint = "https://gateway-publico.pucapi.puc-campinas.edu.br/mobile/v3/alunos/disciplinascursadas/"
        let login = UserDefaults.standard.string(forKey: "login")
        if let url = URL(string: endpoint) {
            guard let login = login else {
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Basic \(login)", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: URLRequest(url: url), completionHandler: { (data, response, error) in
                if error != nil {
                    print("Error = \(String(describing: error))")
                    return
                }
                guard let data = data else {
                    return
                }
                do {
                    let completedSubject  = try JSONDecoder().decode([CompletedSubjects].self, from: data)
                    callback(completedSubject)
                } catch let jsonError {
                    print(jsonError)
                }
            }).resume()
        } else {
            //URL is invalid
        }
    }
    
    func getWeekSchedule(callback: @escaping((_ subjects: [Schedule]) -> Void)) {
        let endpoint = "https://gateway-publico.pucapi.puc-campinas.edu.br/mobile/v3/alunos/gradehoraria"
        let login = UserDefaults.standard.string(forKey: "login")
        if let url = URL(string: endpoint) {
            guard let login = login else {
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Basic \(login)", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    print("Error = \(String(describing: error))")
                    return
                }
                guard let data = data else {
                    return
                }
                do {
                    let schedule  = try JSONDecoder().decode([Schedule].self, from: data)
                    callback(schedule)
                } catch let jsonError {
                    print(jsonError)
                }
            }.resume()
        } else {
            print("Invalid URL for getWeekSchedule")
        }
    }
    
    //Set attendance icon
    func setAttendanceIcon(attendance: Float) -> Bool {
        if attendance > 70.0 {
            return true
        } else {
            return false
        }
    }
}
