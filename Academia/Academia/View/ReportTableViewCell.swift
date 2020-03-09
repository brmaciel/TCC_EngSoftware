//
//  RelatorioTableViewCell.swift
//  Academia
//
//  Created by Bruno Maciel on 8/26/19.
//  Copyright © 2019 Bruno Maciel. All rights reserved.
//

import UIKit

class ReportTableViewCell: UITableViewCell {

    // MARK: Outlets
    @IBOutlet weak var lb_nome: UILabel!
    @IBOutlet weak var lb_cpf: UILabel!
    @IBOutlet weak var lb_identidade: UILabel!
    @IBOutlet weak var lb_endereco: UILabel!
    @IBOutlet weak var lb_planoPagamento: UILabel!
    @IBOutlet weak var lb_dataPagamento: UILabel!
    
    
    
    /**********************************************
                MARK: Override Methods
     **********************************************/
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        
    }
    
    /**********************************************
                    MARK: Methods
     **********************************************/
    func prepareCell(with aluno: Aluno) {
        lb_nome.text = aluno.nome
        lb_cpf.text = aluno.formattedCPF
        lb_identidade.text = aluno.formattedIdentidade
        lb_endereco.text = aluno.endereco.oneline
        lb_planoPagamento.text = aluno.planoAtual
        lb_dataPagamento.text = aluno.ultimoPagamento?.formattedDate(aluno.ultimoPagamento!.proximoPagamento)
        
        if !aluno.isAdimplente {
            lb_nome.textColor = .red
            lb_dataPagamento.textColor = .red
        } else {
            lb_nome.textColor = .black
            lb_dataPagamento.textColor = .black
        }
    }
}
