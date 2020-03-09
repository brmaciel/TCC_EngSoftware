//
//  Pagamento.swift
//  Academia
//
//  Created by Bruno Maciel on 9/2/19.
//  Copyright © 2019 Bruno Maciel. All rights reserved.
//

import Foundation

enum PlanoPagamento: String, Codable {
    case Mensal = "Mensal"
    case Anual = "Anual"
}

final class Pagamento {
    
    // MARK: Properties
    private var _id: String? = nil
    var valor: Float
    var dataPagamento: String
    private var _proximoPagamento: String = ""
    var plano: PlanoPagamento
    
    var proximoPagamento: String {
        get {
            return self._proximoPagamento
        }
    }
    
    // MARK: Construtor
    init(value: Float, dataPagamento: String, plano: PlanoPagamento, nextPayment: String? = nil) {
        self.valor = value
        self.plano = plano
        
        if dataPagamento.count > 10 { // data chega no formato "2019-08-16T03:00:00.000Z"
            self.dataPagamento = String(dataPagamento.prefix(10))
        } else {
            self.dataPagamento = dataPagamento
        }
        
        if nextPayment != nil {
            if nextPayment!.count > 10 {
                self._proximoPagamento = String(nextPayment!.prefix(10))
            } else { self._proximoPagamento = nextPayment! }
        } else {
            self._proximoPagamento = self.computeProximoPagamento()
        }
    }
    
    
    // MARK: Métodos
    func formattedDate(_ date: String) -> String {
        let dateArray = date.components(separatedBy: "-")
        if dateArray.count != 3 { return " / / " }
        let formattedDate = dateArray[2] + "/" + dateArray[1] + "/" + dateArray[0]
        return formattedDate
    }
    
    func delayPaymentDueFerias() {
        // função para adiar o pagamento no registro de ferias
    }
    
    
    // MARK: Métodos Privados
    private func computeProximoPagamento() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let ultimoPg = dateFormatter.date(from: dataPagamento) else { return "" }
        var proxPg: Date
        
        switch plano {
            case .Mensal:
                proxPg = Calendar.current.date(byAdding: .month, value: 1, to: ultimoPg)!
            case .Anual:
                proxPg = Calendar.current.date(byAdding: .year, value: 1, to: ultimoPg)!
        }
        
        return dateFormatter.string(from: proxPg)
    }
}

extension Pagamento: Codable {
    enum DecodKeys: String, CodingKey {
        case id_pagamento = "id_pagamento"
        case valor = "valor"
        case plano = "plano"
        case data_pagamento = "data_pagamento"
        case proximo_pagamento = "proximo_pagamento"
    }
    
    convenience init(from decoder: Decoder) {
        let container = try! decoder.container(keyedBy: DecodKeys.self)
        let id_pagamento: Int = try! container.decode(Int.self, forKey: .id_pagamento)
        let valor: Float = try! container.decode(Float.self, forKey: .valor)
        let plano: PlanoPagamento = try! container.decode(PlanoPagamento.self, forKey: .plano)
        let data_pagamento: String = try! container.decode(String.self, forKey: .data_pagamento)
        let proximo_pagamento: String = try! container.decode(String.self, forKey: .proximo_pagamento)
        
        self.init(value: valor, dataPagamento: data_pagamento, plano: plano, nextPayment: proximo_pagamento)
        self._id = String(id_pagamento)
    }
}
