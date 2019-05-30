//
//  Student.swift
//  PUC Clone
//
//  Created by Tomas Martins on 24/01/19.
//  Copyright © 2019 Tomas Martins. All rights reserved.
//

import Foundation

class Student: Decodable {
    //login
    let ra: String?
    let error: String?
    let message: String?
    //autenticado
    let nome: String?
    let email: String?
    let telefone: String?
    let sexo: String?
    let situacao: String?
    let periodo: String?
    let sitcli: String?
    let curso: Curso?
}

struct Curso: Codable {
    let codigo, nome, turno: String
    let grpCur: Int
    let grpCurDescInterno: String
}
