//
//  StudentModel.swift
//  PUC Clone
//
//  Created by Tomas Martins on 24/01/19.
//  Copyright © 2019 Tomas Martins. All rights reserved.
//

import Foundation
import Sakai
import UIKit

class StudentModel {
    
    func getStudent(username: String, password: String, callback: @escaping ((_ student: Student) -> Void)) {
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        UserDefaults.standard.set(base64LoginString, forKey: "login")
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        // create the request
        let url = URL(string: "https://gateway-publico.pucapi.puc-campinas.edu.br/mobile/v3/usuarios/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("Error = \(String(describing: error))")
                return
            }
            guard let data = data else {
                return
            }
            do {
                let jsonStudent = try JSONDecoder().decode(Student.self, from: data)
                if(jsonStudent.ra != nil) {
                    self.getAuthInfo(callback: {(name) -> Void in
                        DispatchQueue.main.async {
                            callback(name)
                        }
                    })
                } else {
                    //Prints error message
                    if let errorMesage = jsonStudent.message {
                        print(errorMesage)
                    }
                    callback(jsonStudent)
                }
                
            } catch let jsonError {
                print(jsonError)
                return
            }
        }
        task.resume()
    }
    
    func getSakaiSessionToken(callback: @escaping ((_ token: String) -> Void)) {
        let username = UserDefaults.standard.string(forKey: "ra")
        let password = UserDefaults.standard.string(forKey: "senha")
        let endpoint = "http://ead.puc-campinas.edu.br/direct/session/new?_username=\(username ?? "")&_password=\(password ?? "")"
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
                    callback(responseToken)
                }
            }
            task.resume()
        }
    }
    
    func getAvaTitles(token: String, callback: @escaping ((_ titles: AvaSite) -> Void)) {
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
                    let sites  = try? JSONDecoder().decode(AvaSite.self, from: data)
                    //dump(sites)
                    callback(sites!)
                }
            }).resume()
        } else {
            //URL is invalid
        }
    }
    
    
    func getAuthInfo(callback: @escaping ((_ student: Student) -> Void)) {
        let url = "https://gateway-publico.pucapi.puc-campinas.edu.br/mobile/v3/alunos/autenticado"
        let login = UserDefaults.standard.string(forKey: "login")
        if let url = URL(string: url) {
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
                    let student = try JSONDecoder().decode(Student.self, from: data)
                    callback(student)
                } catch let jsonError {
                    print(jsonError)
                }
                
                
            }).resume()
        } else {
            //URL is invalid
        }
    }
    
    
    
    func getTakenClasses(callback: @escaping((_ subjects: [CompletedSubjects]) -> Void)) {
        let endpoint = "https://gateway-publico.pucapi.puc-campinas.edu.br/mobile/v3/alunos/disciplinascursadas/"
        let login = UserDefaults.standard.string(forKey: "login")
        if let url = URL(string: endpoint) {
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
                    let schedule  = try JSONDecoder().decode([Schedule].self, from: data)
                    callback(schedule)
                } catch let jsonError {
                    print(jsonError)
                }
            }).resume()
        } else {
            //URL is invalid
        }
    }
}
