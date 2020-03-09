//
//  AulaTableViewCell.swift
//  Academia
//
//  Created by Bruno Maciel on 8/26/19.
//  Copyright © 2019 Bruno Maciel. All rights reserved.
//

import UIKit

class AulaTableViewCell: UITableViewCell {

    // MARK: Outlets
    @IBOutlet weak var lb_nome: UILabel!
    @IBOutlet weak var lb_instrutor: UILabel!
    @IBOutlet weak var lb_diasDaSemana: UILabel!
    @IBOutlet weak var lb_horario: UILabel!
    @IBOutlet weak var lb_sala: UILabel!
    
    
    
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
    func prepareCell(with aula: Aula) {
        lb_nome.text = aula.nome
        lb_instrutor.text = aula.instrutor?.nome ?? "*sem instrutor definido"
        lb_sala.text = aula.sala
        lb_diasDaSemana.text = aula.diasDaSemana.replacingOccurrences(of: ",", with: ", ") // vem no formato Seg,Ter e transforma para
        lb_horario.text = "\(aula.horarioInicio) - \(aula.horarioFim)"
    }
}
