//
//  DBManager.swift
//  Academia
//
//  Created by Bruno Maciel on 8/26/19.
//  Copyright © 2019 Bruno Maciel. All rights reserved.
//

import Foundation

enum Operation {
    case add
    case update
}
enum Entity: String {
    case aluno = "aluno"
    case instrutor = "instrutor"
    case aula = "aula"
}
enum OrderBy: String {
    case nome = "nome"
    case proximoPagamento = "proximo-pagamento"
}

class DBManager {
    
    // MARK: Construtor
    static let singleton = DBManager()
    private init() {}
    
    
    
    /**********************************************
                MARK: Métodos Públicos
     **********************************************/
    
    func uploadData<T>(_ object: T, mode: Operation, onComplete: @escaping (Bool) -> Void) -> (Bool, String) {
        /* 1) Valida se as informações passadas estão em conformidade com a lógica do Banco de Dados
         * 2.1) Caso Negativo: Retorna a falha, indicando os problemas de não conformidade
         * 2.2) Caso Positivo: Seguirá para as operações de acesso ao Banco de Dados
         * 3) Envia JSON para a API REST com a query em SQL
        */
        var success = true
        var error = ""
        var objectId = ""
        var resource: APIResource = .aluno
        
        if let instrutor = object as? Instrutor {
            (success, error) = validateInstrutorData(instrutor)
            objectId = instrutor.id ?? ""
            resource = .instrutor
        }
        else if let aula = object as? Aula {
            (success, error) = validateAulaData(aula)
            objectId = aula.id ?? ""
            resource = .aula
        }
        
        if !success { return (success, error) }
        
        let (wasCreated, jsonData) = createJSON(for: object)
        if !wasCreated { onComplete(false) }
        
        switch mode {
            case .add:
                REST.postObject(jsonData, resource: resource) { (success) in
                    onComplete(success)
                    print("Acesso ao Banco de Dados concluído")
                }
            case .update:
                REST.putObject(jsonData, resource: resource, withId: objectId) { (success) in
                    onComplete(success)
                    print("Acesso ao Banco de Dados concluído")
                }
        }
        
        return (success, error)
    }
    
    func deleteData<T>(_ object: T, onComplete: @escaping (Bool) -> Void) {
        var objectId = ""
        var resource: APIResource
        
        if let instrutor = object as? Instrutor {
            resource = .instrutor
            objectId = instrutor.id!
        }
        else if let aluno = object as? Aluno {
            resource = .aluno
            objectId = aluno.matricula!
        }
        else if let aula = object as? Aula {
            resource = .aula
            objectId = aula.id!
        } else { return }
        
        let (success, jsonData) = createJSON(for: object)
        if !success { return }
        
        // Exclusão de registro no banco de dados através da API REST
        REST.deleteObject(jsonData, resource: resource, withId: objectId) { (success) in
            onComplete(success)
            print("Acesso ao Banco de Dados concluído")
        }
    }
    
    private func createJSON<T>(for object: T) -> (Bool, Data) {
        print("Criando JSON")
        if let instrutor = object as? Instrutor {
            guard let json = try? JSONEncoder().encode(instrutor) else { print("\nErro ao criar json"); return (false, Data())}
            return (true, json)
        }
        else if let aluno = object as? Aluno {
            guard let json = try? JSONEncoder().encode(aluno) else { print("\nErro ao criar json"); return (false, Data())}
            return (true, json)
        }
        else if let aula = object as? Aula {
            guard let json = try? JSONEncoder().encode(aula) else { print("\nErro ao criar json"); return (false, Data())}
            return (true, json)
        } else { return (false, Data()) }
    }
    
    
    
    /**************************************************
        MARK: Métodos privados de Validação de Inputs
     **************************************************/
    
    private func validateInstrutorData(_ instrutor: Instrutor) -> (Bool, String) {
        var dataValidated = true
        var error = ""
        
        if instrutor.nome.count > 50 || instrutor.nome.isEmpty {
            dataValidated = false
            error += "Nome inválido. (máx 50 caracteres)\n"
        }
        if !validateCPF(instrutor.cpf) {
            dataValidated = false
            error += "CPF inválido. Insira somente dígitos (11)\n"
        }
        if !validateIdentidade(instrutor.identidade) {
            dataValidated = false
            error += "Número de Identidade inválido. Insira somente dígitos (9)\n"
        }
        return (dataValidated, error)
    }
    
    private func validateAulaData(_ aula: Aula) -> (Bool, String) {
        var dataValidated = true
        var error = ""
        
        if aula.nome.count > 30 || aula.nome.isEmpty {
            dataValidated = false
            error += "Nome inválido. (máx 50 caracteres)\n"
        }
        if aula.diasDaSemana == "" {
            dataValidated = false
            error += "Dias inválidos. Insira os dias da semana\n"
        }
        if aula.horarioInicio >= aula.horarioFim {
            dataValidated = false
            error += "Horário inválido. Início deve ser anterior ao Fim\n"
        }
        if aula.horarioInicio == "" || aula.horarioFim == ""{
            dataValidated = false
            error += "Horário inválido. Insira os horários\n"
        }
        if aula.sala.count > 4 || aula.sala.isEmpty {
            dataValidated = false
            error += "Nome da sala inválido. (máx. 4 caracteres)\n"
        }
        return (dataValidated, error)
    }
    
    private func validateCPF(_ cpf: String) -> Bool {
        if Int(cpf) == nil { return false }
        if cpf.count != 11 { return false }
        return true
    }
    
    private func validateIdentidade(_ identidade: String) -> Bool {
        if Int(identidade) == nil { return false }
        if identidade.count != 9 { return false }
        return true
    }
    
    
    
    /***************************************************
        Métodos de Acesso de Leitura ao Banco de Dados
     ***************************************************/
    
    func search(for object: Entity, WhereNomeOrIdEquals value: String, onComplete: @escaping ([Instrutor]) -> Void) {
        let searchValue = "/\(value)".replacingOccurrences(of: " ", with: "%20")
        // Espaços devem ser substituidos por '%20', por conta da url
        
        switch object {
            case .instrutor:
                REST.getInstrutor(with: searchValue, resource: .instrutor, onComplete: { (instrutores) in
                    onComplete(instrutores)
                    print("Acesso ao Banco de Dados concluído")
                }) { (error) in
                    switch error {
                    case .url:
                        print("URL Inválida")
                    case .taskError:
                        print("Falha na criação da tarefa")
                    case .noResponse:
                        print("Sem resposta do servidor")
                    case .responseStatusCode:
                        print("Servidor respondeu com erro")
                    case .noData:
                        print("Sem dados na resposta do servidor")
                    case .invalidJSON:
                        print("JSON inválido")
                    }
                    print(error)
                }
            case .aluno:
                return // a implementar
            case .aula:
                return // aula recebera um metodo proprio
        }
    }
    
    func searchForAula(with values: [String], onComplete: @escaping ([Aula]) -> Void) {
        let nomeAula = "aula=\(values[0])"
        let instrutor = "instrutor=\(values[1])"
        let diaSemana = "dias-da-semana=\(values[2].replacingOccurrences(of: ", ", with: ",%25"))"
        let horario = "horario=\(values[3])"
        let sala = "sala=\(values[4])"
        
        let pieces = [nomeAula, instrutor, diaSemana, horario, sala]
        
        var multipleCondition = false
        var queryParams = ""
        for index in 0..<values.count {
            if values[index] != "" {
                queryParams += pieces[index]
                multipleCondition = true
            }
            if multipleCondition && index < values.count-1 && values[index+1] != "" {
                queryParams += "&"
            }
        }
        if queryParams != "" {
            queryParams.insert(contentsOf: "?", at: queryParams.startIndex)
        }
        queryParams = queryParams.replacingOccurrences(of: " ", with: "%20")
        
        REST.getAula(withParameters: queryParams, resource: .aula, onComplete: { (aulas) in
            onComplete(aulas)
            print("Acesso ao Banco de Dados concluído")
        }) { (error) in
            switch error {
            case .url:
                print("URL Inválida")
            case .taskError:
                print("Falha na criação da tarefa")
            case .noResponse:
                print("Sem resposta do servidor")
            case .responseStatusCode:
                print("Servidor respondeu com erro")
            case .noData:
                print("Sem dados na resposta do servidor")
            case .invalidJSON:
                print("JSON inválido")
            }
            print(error)
        }
    }
    
    func searchGroupClassInstrutores(onComplete: @escaping ([Instrutor]) -> Void) {
        /* Metodo chamado quando se vai criar/editar uma aula,
         * e então é necessário resgatar quais instrutores estão habilitados para aulas em grupo
         */
        let queryParams = "?atividade=Aulas em Grupo".replacingOccurrences(of: " ", with: "%20")
        
        REST.getInstrutor(with: queryParams, resource: .instrutor, onComplete: { (instrutores) in
            onComplete(instrutores)
            print("Acesso ao Banco de Dados concluído")
        }) { (error) in
            switch error {
            case .url:
                print("URL Inválida")
            case .taskError:
                print("Falha na criação da tarefa")
            case .noResponse:
                print("Sem resposta do servidor")
            case .responseStatusCode:
                print("Servidor respondeu com erro")
            case .noData:
                print("Sem dados na resposta do servidor")
            case .invalidJSON:
                print("JSON inválido")
            }
            print(error)
        }
    }
    
    func getPaymentReport(orderBy: OrderBy, onComplete: @escaping (Bool, [Aluno]?) -> Void) {
        /* Metodo chamado quando se deseja emitir os relatórios */
        
        let queryParams = "?orderBy=\(orderBy.rawValue)"
        
        REST.getReport(queryParams, onComplete: { (alunos) in
            onComplete(true, alunos)
            print("Acesso ao Banco de Dados concluído")
        }) { (error) in
            switch error {
            case .url:
                print("URL Inválida")
            case .taskError:
                print("Falha na criação da tarefa")
                onComplete(false, nil)
            case .noResponse:
                print("Sem resposta do servidor")
            case .responseStatusCode:
                print("Servidor respondeu com erro")
            case .noData:
                print("Sem dados na resposta do servidor")
            case .invalidJSON:
                print("JSON inválido")
            }
            print(error)
        }
    }
    
    
    
    /***************************************************
        Métodos de Coleta de Dados de arquivos JSON
     ***************************************************/
    // será utilizado na criação dos Estados e Cidades
    /*func getJSON_cidades() -> [String] {
        return []
    }
    
    func getJSON_aulas() -> [Aula] {
        let sqlRequestAnswers: [Aula]
        
        let fileURL = Bundle.main.url(forResource: "aulas", withExtension: "json")!
        let jsonData = try! Data(contentsOf: fileURL)
        do {
            sqlRequestAnswers = try JSONDecoder().decode([Aula].self, from: jsonData)
        } catch {
            print(error.localizedDescription)
            return []
        }
        return sqlRequestAnswers
    }*/
}
