//
//  AddEditInstrutorViewController.swift
//  Academia
//
//  Created by Bruno Maciel on 8/23/19.
//  Copyright © 2019 Bruno Maciel. All rights reserved.
//

import UIKit

class AddEditInstrutorViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var lb_title: UILabel!
    @IBOutlet weak var field_nome: UITextField!
    @IBOutlet weak var field_cpf: UITextField!
    @IBOutlet weak var field_identidade: UITextField!
    @IBOutlet weak var sc_tipoAtividade: UISegmentedControl!
    @IBOutlet weak var btn_save: UIButton!
    
    
    // MARK: Properties
    var instrutor: Instrutor?
    let dbManager = DBManager.singleton
    
    
    
    /**********************************************
                MARK: Override Methods
     **********************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()

        checkExistingInstrutor()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    
    /**********************************************
                    MARK: Métodos
     **********************************************/
    
    func checkExistingInstrutor() {
        guard let instrutor = instrutor else { return }
        print("Editando o Instrutor: \(instrutor.nome)")
        
        lb_title.text = "Editar Instrutor"
        field_nome.text = instrutor.nome
        field_cpf.text = instrutor.cpf
        field_identidade.text = instrutor.identidade
        sc_tipoAtividade.selectedSegmentIndex = sc_tipoAtividade.titleForSegment(at: 0) == instrutor.atividade ? 0 : 1
    }
    
    func showSuccessFailAlert(success: Bool, error: String = "Falha ao armazenar dados no servidor!") {
        if success {
            let alert = UIAlertController(title: "SUCESSO", message: "Dados foram armazenados com sucesso!", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (nil) in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(OKAction)
            present(alert, animated: true, completion: nil)
        } else {
            // Dados inseridos não estão em conformidade com o esperado.
            // Será exibido um alerta indicando os problemas encontrados.
            print(error)
            
            let alert = UIAlertController(title: "ERROR", message: error, preferredStyle: .alert)
            let OKAction =  UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(OKAction)
            present(alert, animated: true, completion: nil)
        }
        btn_save.isEnabled = true
    }
    
    
    
    /**********************************************
                MARK: Button Actions
     **********************************************/
    
    @IBAction func saveData(_ sender: UIButton) {
        sender.isEnabled = false
        var success: Bool
        var dataValidationError: String
        
        if instrutor == nil {
            // Cria novo Instrutor
            print("Criando novo Instrutor")
            
            instrutor = Instrutor(field_nome.text!, cpf: field_cpf.text!, identidade: field_identidade.text!, atividade: sc_tipoAtividade.titleForSegment(at: sc_tipoAtividade.selectedSegmentIndex)!)
            (success, dataValidationError) = dbManager.uploadData(instrutor, mode: .add, onComplete: { (success) in
                DispatchQueue.main.async {
                    self.showSuccessFailAlert(success: success)
                    if !success { self.instrutor = nil }
                }
            })
            
            /* Se houver erro de conformidade ao criar um novo instrutor,
             * o reseta para que o considere um novo instrutor novamente na próxima vez que o salvar,
             * caso contrario seria consderado um instrutor já existente, e chamaria a funcão de update
             * mesmo que ainda não possuísse um id configurado
             */
            if !success { instrutor = nil }
        } else {
            // Editando dados de um Instrutor
            print("Tentando salvar a edição do Instrutor: \(instrutor!.nome)")
            
            instrutor!.update(field_nome.text!, cpf: field_cpf.text!, identidade: field_identidade.text!, atividade: sc_tipoAtividade.titleForSegment(at: sc_tipoAtividade.selectedSegmentIndex)!)
            (success, dataValidationError) = dbManager.uploadData(instrutor, mode: .update, onComplete: { (success) in
                DispatchQueue.main.async {
                    self.showSuccessFailAlert(success: success)
                    
                }
            })
        }
        
        if !success {
            showSuccessFailAlert(success: success, error: dataValidationError)
        }
    }
    
    @IBAction func closeScreen(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
