//
//  REST.swift
//  Academia
//
//  Created by Bruno Maciel on 8/31/19.
//  Copyright © 2019 Bruno Maciel. All rights reserved.
//

import Foundation

enum APIError {
    case url
    case taskError(error: Error)
    case noResponse
    case noData
    case responseStatusCode(code: Int)
    case invalidJSON
}

fileprivate enum RESTMethod: String {
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum APIResource: String {
    case instrutor = "instrutores"
    case aula = "aulas"
    case aluno = "alunos"
}

class REST {
    
    // MARK: Private Properties
    private static let basePath = "http://127.0.0.1:3000/"
    private static let configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Content-Type": "application/json"]
        config.timeoutIntervalForRequest = 10.0 // 10s para obter uma resposta, caso contrario cancela a requisição
        config.httpMaximumConnectionsPerHost = 5 // numero maximo de conexoes simultaneas
        return config
    }()
    private static let session =  URLSession (configuration: configuration) // URLSession.shared
    
    
    
    /**********************************************
                    MARK: Métodos GET
     **********************************************/
    
    class func getInstrutor(with searchValue: String, resource: APIResource, onComplete: @escaping ([Instrutor]) -> Void , onError: @escaping (APIError) -> Void) {
        let completePath = basePath + resource.rawValue + searchValue // 127.0.0.1:3000/ + instrutores + (/nome || ?atividade=Aulas em Grupo)
        print("Path: ", completePath)
        
        guard let url = URL(string: completePath) else { onError(.url); return }
        
        let dataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            //json chegara na variavel data
            if error == nil {
                guard let response = response as? HTTPURLResponse else { onError(.noResponse); return } // Sem resposta
                
                if response.statusCode == 200 {
                    guard let data = data else {onError(.noData); return } // Sem dados na resposta
                    
                    do {
                        let instrutorList = try JSONDecoder().decode([Instrutor].self, from: data)
                        onComplete(instrutorList)
                    } catch {
                        print(error.localizedDescription)
                        onError(.invalidJSON) // JSON invalido
                    }
                } else {
                    onError(.responseStatusCode(code: response.statusCode)) // Algum status inválido pelo servidor
                }
            } else {
                onError(.taskError(error: error!)) // erros do aplicativo
            }
        }
        dataTask.resume() // executa a tarefa
    }
    
    class func getAula(withParameters queryParam: String, resource: APIResource, onComplete: @escaping ([Aula]) -> Void , onError: @escaping (APIError) -> Void) {
        let completePath = basePath + resource.rawValue + queryParam
        print("Path: ", completePath)
        
        guard let url = URL(string: completePath) else { onError(.url); return }
        
        let dataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error == nil {
                guard let response = response as? HTTPURLResponse else { onError(.noResponse); return }
                
                if response.statusCode == 200 {
                    guard let data = data else {onError(.noData); return } // Sem dados na resposta
                    
                    do {
                        let aulasList = try JSONDecoder().decode([Aula].self, from: data)
                        onComplete(aulasList)
                    } catch {
                        print(error.localizedDescription)
                        onError(.invalidJSON) // JSON invalido
                    }
                } else {
                    onError(.responseStatusCode(code: response.statusCode))
                }
            } else {
                onError(.taskError(error: error!))
            }
        }
        dataTask.resume()
    }
    
    class func getReport(_ orderBy: String, onComplete: @escaping ([Aluno]) -> Void, onError: @escaping (APIError) ->Void) {
        let completePath = basePath + "relatorio" + orderBy
        
        guard let url = URL(string: completePath) else { onError(.url); return }
        
        let dataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error == nil {
                guard let response = response as? HTTPURLResponse else { onError(.noResponse); return }
                
                if response.statusCode == 200 {
                    guard let data = data else { onError(.noData); return }
                    
                    do {
                        let pagamentosList = try JSONDecoder().decode([Aluno].self, from: data)
                        onComplete(pagamentosList)
                    } catch {
                        print(error.localizedDescription)
                        onError(.invalidJSON)
                    }
                } else { onError(.responseStatusCode(code: response.statusCode)) }
            } else { onError(.taskError(error: error!)) }
        }
        dataTask.resume()
    }
    
    
    
    /**********************************************
            MARK: Métodos POST - PUT - DELETE
     **********************************************/
    
    class func postObject(_ json: Data, resource: APIResource, onComplete: @escaping (Bool) -> Void) {
        let resourcePath = resource.rawValue
        
        applyOperation(json, path: resourcePath, method: .post, onComplete: onComplete)
    }
    
    class func putObject(_ json: Data, resource: APIResource, withId id: String, onComplete: @escaping (Bool) -> Void) {
        let resourcePath = resource.rawValue + "/" + id
        
        applyOperation(json, path: resourcePath, method: .put, onComplete: onComplete)
    }
    
    class func deleteObject(_ json: Data, resource: APIResource, withId id: String, onComplete: @escaping (Bool) -> Void) {
        let resourcePath = resource.rawValue + "/" + id
        
        applyOperation(json, path: resourcePath, method: .delete, onComplete: onComplete)
    }
    
    
    // MARK: Método privado utilizado pelos Métodos POST, PUT e DELETE
    private class func applyOperation(_ json: Data, path resourcePath: String, method: RESTMethod, onComplete: @escaping (Bool) -> Void) {
        let completePath = basePath + resourcePath
        
        guard let url = URL(string: completePath) else { print("\nErro na criação da url"); return }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = json
        
        let dataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if error == nil {
                guard let response = response as? HTTPURLResponse else { print("\nErro na obtenção da response"); onComplete(false); return }
                
                if response.statusCode == 200 {
                    guard data != nil else { print("\nErro na obtenção do data"); onComplete(false); return }
                    
                    print("Data received: \(data!)")
                    onComplete(true)
                } else { print("\nErro de Status Code: \(response.statusCode)"); onComplete(false) }
            } else {
                print("\nErro na criação do DataTask: \n\(error!)")
                onComplete(false)
            }
        }
        dataTask.resume()
    }
}
