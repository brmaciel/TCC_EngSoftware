//
//  Aula.swift
//  Academia
//
//  Created by Bruno Maciel on 8/26/19.
//  Copyright © 2019 Bruno Maciel. All rights reserved.
//

import Foundation
    
final class Aula {
    
    // MARK: Properties
    private var _id: String? = nil
    var nome: String
    var horarioInicio: String
    var horarioFim: String
    var diasDaSemana: String
    var sala: String
    var instrutor: Instrutor?
    
    var id: String? {
        get {
            return self._id
        }
    }
    
    
    // MARK: Construtor
    init(_ nome: String, from inicio: String, to fim: String, on dias: String, sala: String, by instrutor: Instrutor?) {
        self.nome = nome
        self.horarioInicio = inicio.count > 5 ? String(inicio.dropLast(3)) : inicio // TIME retorna como hh:mm:ss, então retiramos o :ss
        self.horarioFim = inicio.count > 5 ? String(fim.dropLast(3)) : fim
        self.diasDaSemana = dias
        self.sala = sala
        self.instrutor = instrutor
        
        // se o id do instrutor passado for nil, significa que a aula não possui um instrutor designado ainda
        if instrutor?.id == nil {
            self.instrutor = nil
        } else {
            self.instrutor = instrutor
        }
    }
    
    
    // MARK: Métodos
    func update(_ nome: String, from inicio: String, to fim: String, on dias: String, sala: String, by instrutor: Instrutor?) {
        self.nome = nome
        self.horarioInicio = inicio
        self.horarioFim = fim
        self.diasDaSemana = dias
        self.sala = sala
        self.instrutor = instrutor
    }
}



// MARK: Extensão JSON
extension Aula: Codable {
    
    enum MyKeys: String, CodingKey {
        case id_aula = "id_aula"
        case nome_aula = "nome_aula"
        case horario_inicio = "horario_inicio"
        case horario_fim = "horario_fim"
        case dia_semana = "dia_semana"
        case sala = "sala"
        case instrutor = "instrutor"
    }
    
    convenience init(from decoder: Decoder) {
        let container = try! decoder.container(keyedBy: MyKeys.self)
        let id_aula: Int = try! container.decode(Int.self, forKey: .id_aula)
        let nome_aula: String = try! container.decode(String.self, forKey: .nome_aula)
        let horario_inicio: String = try! container.decode(String.self, forKey: .horario_inicio)
        let horario_fim: String = try! container.decode(String.self, forKey: .horario_fim)
        let dia_semana: String = try! container.decode(String.self, forKey: .dia_semana)
        let sala: String = try! container.decode(String.self, forKey: .sala)
        let instrutores: [Instrutor] = try! container.decode([Instrutor].self, forKey: .instrutor)
        
        self.init(nome_aula, from: horario_inicio, to: horario_fim, on: dia_semana, sala: sala, by: instrutores[0])
        self._id = String(id_aula)
    }
}
