//
//  PeopleViewController.swift
//  Academia
//
//  Created by Bruno Maciel on 8/23/19.
//  Copyright © 2019 Bruno Maciel. All rights reserved.
//

import UIKit

class PeopleViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var sc_alunoInstrutor: UISegmentedControl!
    @IBOutlet weak var field_search: UITextField!
    @IBOutlet weak var alunoInstrutorTableView: UITableView!
    
    // Outlets for Aluno View
    @IBOutlet weak var view_aluno: UIView!
    @IBOutlet weak var constraint_alunoBottom: NSLayoutConstraint!
    @IBOutlet weak var lb_matricula: UILabel!
    @IBOutlet weak var lb_nomeAluno: UILabel!
    @IBOutlet weak var lb_cpfAluno: UILabel!
    @IBOutlet weak var lb_identidadeAluno: UILabel!
    @IBOutlet weak var lb_endereco: UILabel!
    @IBOutlet weak var lb_plano: UILabel!
    @IBOutlet weak var lb_nextPagamento: UILabel!
    @IBOutlet weak var lb_adimplencia: UILabel!
    @IBOutlet weak var lb_nextAvaliacao: UILabel!
    
    // Outlets for Instrutor View
    @IBOutlet weak var view_instrutor: UIView!
    @IBOutlet weak var constraint_instrutorTop: NSLayoutConstraint!
    @IBOutlet weak var lb_idInstrutor: UILabel!
    @IBOutlet weak var lb_nomeInstrutor: UILabel!
    @IBOutlet weak var lb_cpfInstrutor: UILabel!
    @IBOutlet weak var lb_identidadeInstrutor: UILabel!
    @IBOutlet weak var lb_tipoAtividade: UILabel!
    
    
    // MARK: Properties
    var aluno: Aluno?
    var instrutor: Instrutor?
    var alunosList: [Aluno]?
    var instrutorList: [Instrutor]?
    let dbManager = DBManager.singleton
    
    private var searchingAluno = true
    
    
    // MARK: UI Elements
    var lb_emptyTableView : UILabel = {
        let label = UILabel()
        label.text = "Realize uma busca"
        label.font = label.font.withSize(12)
        label.textAlignment = .center
        label.textColor = UIColor(named: "main")
        return label
    }()
    
    
    
    /**********************************************
                MARK: Override Methods
     **********************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()

        constraint_alunoBottom.constant = 0
        constraint_instrutorTop.constant = 0
        view_aluno.isHidden = true
        view_instrutor.isHidden = true
        
        alunoInstrutorTableView.backgroundView = lb_emptyTableView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        alunoInstrutorTableView.reloadData()
        
        guard let selectedInstrutor = instrutor else {return}
        lb_idInstrutor.text = selectedInstrutor.id
        lb_nomeInstrutor.text = selectedInstrutor.nome
        lb_cpfInstrutor.text = selectedInstrutor.formattedCPF
        lb_identidadeInstrutor.text = selectedInstrutor.formattedIdentidade
        lb_tipoAtividade.text = selectedInstrutor.atividade
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    
    /**********************************************
                    MARK: Methods
     **********************************************/
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.alunoInstrutorTableView.reloadData() // recarrega a tableView com os Alunos/Instrutores obtidos na pesquisa
        }
    }
    
    func showDeleteAlert(message: String) {
        let deleteAlert = UIAlertController(title: "Confirme Deleção", message: message, preferredStyle: .alert)
        let btn_cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        let btn_confirm = UIAlertAction(title: "Sim", style: .default) { (nil) in
            self.proceedToDelete()
        }
        deleteAlert.addAction(btn_cancel)
        deleteAlert.addAction(btn_confirm)
        present(deleteAlert, animated: true, completion: nil)
    }
    
    func proceedToDelete() {
        var row = 0
        for index in 0..<instrutorList!.count {
            if instrutor?.id == instrutorList![index].id {
                row = index
                break
            }
        }
        
        dbManager.deleteData(instrutor) { (success) in
            if success {
                DispatchQueue.main.async {
                    self.instrutorList?.remove(at: row)
                    self.alunoInstrutorTableView.deleteRows(at: [IndexPath(row: row, section: 0)], with: .fade)
                    self.view_instrutor.isHidden = true
                    self.instrutor = nil
                }
            }
        }
    }
    
    
    /**********************************************
                MARK: Button Actions
     **********************************************/
    
    // Procura por Aluno/Instrutor
    @IBAction func searchAlunoInstrutor(_ sender: UIButton) {
        view_aluno.isHidden = true
        view_instrutor.isHidden = true
        aluno = nil
        instrutor = nil
        
        if sc_alunoInstrutor.titleForSegment(at: sc_alunoInstrutor.selectedSegmentIndex) == "Aluno" {
            searchingAluno = true
            
            //dbManager.search(for .aluno, WhereNomeIdEquals: field_search.text!)
        } else {
            searchingAluno = false
            dbManager.search(for: .instrutor, WhereNomeOrIdEquals: field_search.text!) { (instrutores) in
                self.instrutorList = instrutores
                self.reloadTableView()
            }
        }
        view.endEditing(true)
    }
    
    // Vai para Tela de Edição de Aluno/Instrutor
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editAlunoSegue" {
            let vc = segue.destination as! AddEditAlunoViewController
            vc.aluno = aluno
        }
        if segue.identifier == "editInstrutorSegue" {
            let vc = segue.destination as! AddEditInstrutorViewController
            vc.instrutor = instrutor
        }
    }
    
    // Vai para Tela de Adicionar Aluno/Instrutor
    @IBAction func addAluno(_ sender: UIButton) {
        performSegue(withIdentifier: "addAlunoSegue", sender: nil)
    }
    @IBAction func addInstrutor(_ sender: UIButton) {
        performSegue(withIdentifier: "addInstrutorSegue", sender: nil)
    }
    
    // Excluir Aluno/Instrutor selecionado
    @IBAction func deleteAluno(_ sender: UIButton) {
        //let deleteMessage = "Tem certeza que deseja excluir o Aluno:\n\"\(aluno!.nome)\"?"
        
        //showDeleteAlert(message: deleteMessage)
    }
    
    @IBAction func deleteInstrutor(_ sender: UIButton) {
        let deleteMessage = "Tem certeza que deseja excluir o Instrutor:\n\"\(instrutor!.nome)\"?"
        
        showDeleteAlert(message: deleteMessage)
    }
}



    /**********************************************
        MARK: Métodos de Controle do TableView
    **********************************************/

extension PeopleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /* A quantidade de celulas na TableView é a quantidade de alunos/instrutores encontrados */
        
        if searchingAluno {
            guard let nCells = alunosList?.count else { return 0 }
            if nCells == 0 {
                lb_emptyTableView.text = "Nenhum aluno foi encontrado"
                tableView.backgroundView = lb_emptyTableView
            } else {tableView.backgroundView = nil}
            return nCells
        } else {
            guard let nCells = instrutorList?.count else { return 0 }
            if nCells == 0 {
                lb_emptyTableView.text = "Nenhum instrutor foi encontrado"
                tableView.backgroundView = lb_emptyTableView
            } else {tableView.backgroundView = nil}
            
            return nCells
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if searchingAluno {
            cell.textLabel?.text = "Nome do Aluno"
            cell.detailTextLabel?.text = "matricula"
        } else {
            cell.textLabel?.text = instrutorList?[indexPath.row].nome ?? ""
            cell.detailTextLabel?.text = instrutorList?[indexPath.row].id ?? ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /* Ao selecionar um item na TableView, é exibida a informação na tela ao lado */
        
        let index = indexPath.row
        
        if searchingAluno {
            view_instrutor.isHidden = true
            view_aluno.isHidden = false
            
            guard let selectedAluno = alunosList?[index]  else { return }
            
            aluno = selectedAluno
            
            lb_matricula.text = selectedAluno.matricula
            lb_nomeAluno.text = selectedAluno.nome
            lb_cpfAluno.text = selectedAluno.formattedCPF
            lb_identidadeAluno.text = selectedAluno.formattedIdentidade
            lb_endereco.text = selectedAluno.endereco.oneline
            
            lb_plano.text = selectedAluno.planoAtual
            lb_nextPagamento.text = "dd/mm/aaaa"
            if selectedAluno.isAdimplente {
                lb_adimplencia.text = "Adimplente"
                lb_adimplencia.textColor = UIColor(red: 0.0, green: 144/255, blue: 81/255, alpha: 1.0)
            } else {
                lb_adimplencia.text = "Inadimplente"
                lb_adimplencia.textColor = .red
            }
            lb_nextAvaliacao.text = "dd/mm/aaaa"
            
        } else {
            view_aluno.isHidden = true
            view_instrutor.isHidden = false
            
            guard let selectedInstrutor = instrutorList?[index] else { return }
            
            instrutor = selectedInstrutor
            print("Instrutor Selecionado: \(instrutor!.nome)")
            
            lb_idInstrutor.text = selectedInstrutor.id
            lb_nomeInstrutor.text = selectedInstrutor.nome
            lb_cpfInstrutor.text = selectedInstrutor.formattedCPF
            lb_identidadeInstrutor.text = selectedInstrutor.formattedIdentidade
            lb_tipoAtividade.text = selectedInstrutor.atividade
        }
    }
}
