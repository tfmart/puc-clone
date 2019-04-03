//
//  Subjects.swift
//  PUC Clone
//
//  Created by Tomas Martins on 26/01/19.
//  Copyright © 2019 Tomas Martins. All rights reserved.
//

import Foundation

//Autenticado
struct Subject: Decodable  {
    let curso: String?
    let nome: String?
    let turno: String?
    let grpCur: Int?
    let grpCurDescInterno: String?
}
