//
//  CompletedSubjects.swift
//  PUC Clone
//
//  Created by Tomas Martins on 26/01/19.
//  Copyright © 2019 Tomas Martins. All rights reserved.
//

import Foundation

struct CompletedSubjects: Decodable {
    let codigo: String?
    let aass: String?
    let codCurso: String?
    let nome: String?
    let media: String?
    let cargaHoraria: String?
    let sitcli: String?
    let decSitcli: String?
}

struct BasicSubject {
    let name: String?
    let grade: String?
    let acceptance: String?
    let code: String?
    let hours: String?
}

struct CompletedTableCell {
    let yearSection: String?
    let subjects: [BasicSubject]?
}
