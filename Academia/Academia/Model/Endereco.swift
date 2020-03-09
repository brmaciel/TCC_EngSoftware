//
//  Endereco.swift
//  Academia
//
//  Created by Bruno Maciel on 8/26/19.
//  Copyright © 2019 Bruno Maciel. All rights reserved.
//

import Foundation

enum Estado: String {
    case Acre = "AC" // Norte
    case Amazonas = "AM"
    case Amapá = "AP"
    case Pará = "PA"
    case Rondonia = "RO"
    case RR
    case TO
    case AL // Nordeste
    case BA
    case CE
    case MA
    case PB
    case PE
    case PI
    case RN
    case SE
    case DF // Centro Oeste
    case GO
    case MS
    case MT
    case ES // Sudeste
    case MG
    case RJ
    case SP
    case PR // Sul
    case RS
    case SC
}

final class Endereco: Codable {
    
    // MARK: Properties
    var rua: String
    var numero: String
    var complemento: String?
    var cidade: String
    var estado: String
    var cep: String
    
    
    // MARK: Computed Properties
    var oneline : String {
        // Rua 7 de setembro, 390, Apt 203, Rio de Janeiro, RJ - 29077149
        // Rua 7 de setembro, 390, Rio de Janeiro, RJ - 29077149
        var end = "\(rua), \(numero), "
        end += complemento != nil && complemento != "" ? "\(complemento!), " : ""
        end += "\n\(self.cidade), \(self.estado) - \(self.cep)"
        return end
    }
    
    
    // MARK: Construtor
    init(rua: String, numero: String, complemento: String?, cidade: String, estado: String, cep: String) {
        self.rua = rua
        self.numero = numero
        self.complemento = complemento ?? ""
        self.cidade = cidade
        self.estado = estado
        self.cep = cep
    }
}
