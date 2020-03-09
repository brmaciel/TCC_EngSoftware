//
//  Instrutor.swift
//  Academia
//
//  Created by Bruno Maciel on 8/26/19.
//  Copyright © 2019 Bruno Maciel. All rights reserved.
//

import Foundation

final class Instrutor {
    
    // MARK: Properties
    private var _id: String? = nil
    var nome: String
    var cpf: String
    var identidade: String
    var atividade: String
    
    var id: String? {
        get {
            return _id
        }
    }
    
    
    // MARK: Computed Properties
    var formattedCPF : String {
        var nCpf = cpf
        nCpf.insert("-", at: nCpf.index(nCpf.startIndex, offsetBy: 9))
        nCpf.insert(".", at: nCpf.index(nCpf.startIndex, offsetBy: 6))
        nCpf.insert(".", at: nCpf.index(nCpf.startIndex, offsetBy: 3))
        return nCpf
    }
    
    var formattedIdentidade : String {
        var nId = identidade
        nId.insert("-", at: nId.index(nId.startIndex, offsetBy: 8))
        nId.insert(".", at: nId.index(nId.startIndex, offsetBy: 5))
        nId.insert(".", at: nId.index(nId.startIndex, offsetBy: 2))
        return nId
    }
    
    
    // MARK: Construtor
    init(_ nome: String, cpf: String, identidade: String, atividade: String) {
        self.nome = nome
        self.cpf = cpf
        self.identidade = identidade
        self.atividade = atividade
    }
    
    
    // MARK: Métodos
    func update(_ nome: String, cpf: String, identidade: String, atividade: String) {
        self.nome = nome
        self.cpf = cpf
        self.identidade = identidade
        self.atividade = atividade
    }
}



// MARK: Extensão JSON
extension Instrutor: Codable {
    
    enum MyKeys: String, CodingKey {
        case id_instrutor = "id_instrutor"
        case nome = "nome"
        case cpf = "cpf"
        case identidade = "identidade"
        case atividade = "atividade"
    }
    
    convenience init(from decoder: Decoder) {
        let container = try! decoder.container(keyedBy: MyKeys.self)
        let id_instrutor: Int? = try? container.decode(Int.self, forKey: .id_instrutor)
        let nome: String? = try? container.decode(String.self, forKey: .nome)
        let cpf: String? = try? container.decode(String.self, forKey: .cpf)
        let identidade: String? = try? container.decode(String.self, forKey: .identidade)
        let atividade: String? = try? container.decode(String.self, forKey: .atividade)
        
        self.init(nome ?? "", cpf: cpf ?? "", identidade: identidade ?? "", atividade: atividade ?? "")
        if let id_instrutor = id_instrutor {
            self._id = String(id_instrutor)
        } else {
            self._id = nil
        }
        
        // É possível que uma aula esteja cadastrada sem instrutor
        // Nesse caso, inicializa um instrutor com todos os atributos vazio e o atributo id = nil
    }
}
