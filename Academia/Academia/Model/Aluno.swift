//
//  Aluno.swift
//  Academia
//
//  Created by Bruno Maciel on 8/26/19.
//  Copyright © 2019 Bruno Maciel. All rights reserved.
//

import Foundation

final class Aluno {
    
    // MARK: Properties
    private var _matricula: String? = nil
    var nome: String
    var cpf: String
    var identidade: String
    var endereco: Endereco
    var planoAtual: String
    var ultimoPagamento: Pagamento?
    
    var matricula: String? {
        get {
            return self._matricula
        }
    }
    
    // MARK: Computed Properties
    var isAdimplente: Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let ultimoPagamento = self.ultimoPagamento?.proximoPagamento else {return true}
        
        let lastPayment = dateFormatter.date(from: ultimoPagamento)!
        let today = Date()
        
        if today > lastPayment { return false }
        else { return true }
    }
    
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
    init(_ nome: String, cpf: String, identidade: String, endereco: Endereco, plano: PlanoPagamento, lastPayment: Pagamento? = nil) {
        self.nome = nome
        self.cpf = cpf
        self.identidade = identidade
        self.endereco = endereco
        self.planoAtual = plano.rawValue
        self.ultimoPagamento = lastPayment
    }
}

extension Aluno: Codable {
    enum DecodKeys: String, CodingKey {
        case matricula = "matricula"
        case nome = "nome"
        case identidade = "identidade"
        case cpf = "cpf"
        case endereco = "endereco"
        case plano_atual = "plano_atual"
        case pagamento = "pagamento"
    }
    
    convenience init(from decoder: Decoder) {
        let container = try! decoder.container(keyedBy: DecodKeys.self)
        let matricula: Int = try! container.decode(Int.self, forKey: .matricula)
        let nome: String = try! container.decode(String.self, forKey: .nome)
        let identidade: String = try! container.decode(String.self, forKey: .identidade)
        let cpf: String = try! container.decode(String.self, forKey: .cpf)
        let enderecos: [Endereco] = try! container.decode([Endereco].self, forKey: .endereco)
        let plano_atual: PlanoPagamento = try! container.decode(PlanoPagamento.self, forKey: .plano_atual)
        let pagamento: [Pagamento]? = try? container.decode([Pagamento].self, forKey: .pagamento)
        
        self.init(nome, cpf: cpf, identidade: identidade, endereco: enderecos[0], plano: plano_atual, lastPayment: pagamento?[0])
        self._matricula = String(matricula)
    }
}
