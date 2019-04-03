//
//  StudentWatchModel.swift
//  PUC Clone
//
//  Created by Tomas Martins on 27/02/19.
//  Copyright © 2019 Tomas Martins. All rights reserved.
//

import Foundation

class WatchSchedule: Codable {
    let nomeDisciplina: String?
    let diaSemana: Int?
}

class StudentWatchModel {
    func getTodaysSchedule(callback: @escaping((_ schedule: [String]) -> Void)) {
        var scheduleFromServer: [WatchSchedule] = []
        var todayTitles: [String] = []
        let int = 0
        let todayWeekInt = int.getDayWeekInt()
        let username = "16111312"
        let password = "QPW49!@V"
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
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
                let jsonStudent = try JSONDecoder().decode(WatchSchedule.self, from: data)
                if(jsonStudent.nomeDisciplina != nil) {
                    //Makes String array with titles
                    scheduleFromServer.append(jsonStudent)
                    if jsonStudent.diaSemana == todayWeekInt {
                        todayTitles.append(jsonStudent.nomeDisciplina!)
                    }
                    callback(todayTitles)
                    
                    //callback(array)
                } else {
                    //Login fail
                    callback(["Error"])
                }
                
            } catch let jsonError {
                print(jsonError)
                return
            }
        }
        task.resume()
    }
}
