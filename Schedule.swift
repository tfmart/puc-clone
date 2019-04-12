//
//  Schedule.swift
//  PUC Clone
//
//  Created by Tomas Martins on 15/02/19.
//  Copyright © 2019 Tomas Martins. All rights reserved.
//

import Foundation

class Schedule: Decodable {
    let codigoDisciplina: String?
    let nomeDisciplina: String?
    let horario: String?
    let predio: String?
    let sala: String?
    let professor: String?
    let diaSemana: Int?
    let campus: String?
    let ementa: String?
    let latitude: String?
    let longitude: String?
    let frequencia: Float?
    let codCurso: String?
    let nomeCurso: String?
    let turma: String?
    let aulasDadas: String?
    let aulasFreq: String?
    let datInicio: String?
    let datFinal: String?
    let dataRodizio: String?
    let turno: String?
    let dataUltimoLancFreq: String?
}
