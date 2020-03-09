//
//  AddEditAlunoViewController.swift
//  Academia
//
//  Created by Bruno Maciel on 8/23/19.
//  Copyright © 2019 Bruno Maciel. All rights reserved.
//

import UIKit

class AddEditAlunoViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var lb_title: UILabel!
    @IBOutlet weak var field_nome: UITextField!
    @IBOutlet weak var field_cpf: UITextField!
    @IBOutlet weak var field_identidade: UITextField!
    @IBOutlet weak var field_rua: UITextField!
    @IBOutlet weak var field_numero: UITextField!
    @IBOutlet weak var field_complemento: UITextField!
    @IBOutlet weak var field_cidade: UITextField!
    @IBOutlet weak var field_estado: UITextField!
    @IBOutlet weak var field_cep: UITextField!
    @IBOutlet weak var sc_plano: UISegmentedControl!
    
    
    // MARK: Properties
    var aluno: Aluno?
    
    
    
    /**********************************************
                MARK: Override Methods
     **********************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()

        checkExistingAluno()
    }
    
    
    
    /**********************************************
                    MARK: Methods
     **********************************************/
    
    func checkExistingAluno() {
        guard let aluno = aluno else { return }
        
        lb_title.text = "Editar Aluno"
        field_nome.text = aluno.nome
        field_cpf.text = aluno.cpf
        field_identidade.text = aluno.identidade
        
    }
    
    
    
    /**********************************************
                MARK: Button Actions
     **********************************************/
    
    @IBAction func saveData(_ sender: UIButton) {
        
    }
    
    @IBAction func closeScreen(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
