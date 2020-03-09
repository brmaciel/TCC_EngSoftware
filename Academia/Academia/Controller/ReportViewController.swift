//
//  ReportViewController.swift
//  Academia
//
//  Created by Bruno Maciel on 8/23/19.
//  Copyright © 2019 Bruno Maciel. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var lb_title: UILabel!
    @IBOutlet weak var sw_filtroInadimplencia: UISwitch!
    @IBOutlet weak var sc_sortedReport: UISegmentedControl!
    @IBOutlet weak var lb_pagamento: UILabel!
    @IBOutlet weak var relatorioTableView: UITableView!
    
    
    // MARK: Properties
    var alunosList: [Aluno]?
    var inadimplentesList: [Aluno]?
    let dbManager = DBManager.singleton
    
    private var onlyInadimplentes: Bool = false
    
    
    /**********************************************
                MARK: Override Methods
     **********************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    /**********************************************
                    MARK: Métodos
     **********************************************/
    
    func showFailAlert(failMessage: String = "Falha na Comunicação com o Servidor") {
        // Exibe alerta de falha de comunicação com o servidor
        let failAlert = UIAlertController(title: "ERROR", message: failMessage, preferredStyle:  .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        failAlert.addAction(OKAction)
        present(failAlert, animated: true, completion: nil)
    }
    
    
    
    /**********************************************
                MARK: Button Actions
     **********************************************/

    @IBAction func filterForInadimplentes(_ sender: UISwitch) {
        if sender.isOn {
            lb_title.text = "Relatório de Inadimplência"
            lb_pagamento.text = "Pag. Devido"
            onlyInadimplentes = true
        } else {
            lb_title.text = "Relatório"
            lb_pagamento.text = "Próx. Pagamento"
            onlyInadimplentes = false
        }
        relatorioTableView.reloadData()
    }
    
    @IBAction func createReport(_ sender: UIButton) {
        alunosList = nil
        inadimplentesList = nil
        
        var nomeOrPagamento: OrderBy
        
        if sc_sortedReport.selectedSegmentIndex == 0 { nomeOrPagamento = .nome }
        else { nomeOrPagamento = .proximoPagamento }
        
        /*dbManager.getPaymentReport(orderBy: nomeOrPagamento) { (alunos) in
            self.alunosList = alunos
            self.inadimplentesList = []
            for aluno in self.alunosList! {
                if !aluno.isAdimplente {
                    self.inadimplentesList!.append(aluno)
                }
            }
            DispatchQueue.main.async { self.relatorioTableView.reloadData() }
        }*/
        dbManager.getPaymentReport(orderBy: nomeOrPagamento) { (success, alunos) in
            DispatchQueue.main.async {
                if !success { self.showFailAlert() }
                else {
                    self.alunosList = alunos
                    self.inadimplentesList = []
                    for aluno in self.alunosList! {
                        if !aluno.isAdimplente {
                            self.inadimplentesList!.append(aluno)
                        }
                    }
                    self.relatorioTableView.reloadData()
                }
            }
        }
    }
}



    /**********************************************
        MARK: Métodos de Controle do TableView
    **********************************************/

extension ReportViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if onlyInadimplentes {
            guard let nCells = inadimplentesList?.count else { return 0 }
            return nCells
        } else {
            guard let nCells = alunosList?.count else { return 0 }
            return nCells
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCell", for: indexPath) as! ReportTableViewCell
        
        // configure cell
        if onlyInadimplentes {
            guard let alunoInadimplente = inadimplentesList?[indexPath.row] else { return cell }
            cell.prepareCell(with: alunoInadimplente)
        } else {
            guard let aluno = alunosList?[indexPath.row] else { return cell }
            cell.prepareCell(with: aluno)
        }

        return cell
    }
}
