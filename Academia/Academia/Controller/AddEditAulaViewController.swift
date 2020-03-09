//
//  AddEditAulaViewController.swift
//  Academia
//
//  Created by Bruno Maciel on 8/26/19.
//  Copyright © 2019 Bruno Maciel. All rights reserved.
//

import UIKit

class AddEditAulaViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var lb_title: UILabel!
    @IBOutlet weak var field_nome: UITextField!
    @IBOutlet weak var field_diasDaSemana: UITextField!
    @IBOutlet weak var field_horarioInicio: UITextField!
    @IBOutlet weak var field_horarioFim: UITextField!
    @IBOutlet weak var field_sala: UITextField!
    @IBOutlet weak var field_instrutor: UITextField!
    @IBOutlet weak var btn_delete: UIButton!
    @IBOutlet weak var btn_save: UIButton!
    
    
    // MARK: Properties
    var aula: Aula?
    var instrutor: Instrutor?
    var dbManager = DBManager.singleton
    var instrutoresList: [Instrutor]?
    
    
    // MARK: UI Elements
    lazy var timePickerView: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.backgroundColor = .white
        return datePicker
    }()
    
    lazy var instrutorPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.backgroundColor = .white
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    
    
    /**********************************************
                MARK: Override Methods
     **********************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkExistingAula()
        prepareHorarioTextField()
        loadInstrutores() // Carrega todos os instrutores habilitados a dar aulas em grupo
        prepareInstrutorTextField()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    
    /**********************************************
                    MARK: Methods
     **********************************************/
    
    private func checkExistingAula() {
        guard let aula = aula else { return }
        print("Editando a Aula: \(aula.nome)")
        
        lb_title.text = "Editar Aula"
        btn_delete.isHidden = false
        btn_delete.backgroundColor = .red
        
        instrutor = aula.instrutor
        
        field_nome.text = aula.nome
        field_diasDaSemana.text = aula.diasDaSemana.replacingOccurrences(of: ",", with: ", ") // vem no formato Seg,Ter e transforma para
        field_horarioInicio.text = aula.horarioInicio
        field_horarioFim.text = aula.horarioFim
        field_sala.text = aula.sala
        field_instrutor.text = instrutor?.nome
    }
    
    private func loadInstrutores() {
        dbManager.searchGroupClassInstrutores(onComplete: { (instrutores) in
            self.instrutoresList = instrutores
            DispatchQueue.main.async {
                self.instrutorPickerView.reloadAllComponents()
                
                // PickerView já inicia com o instrutor atual selecionado
                guard let instr = self.instrutor else {return}
                for index in 0..<self.instrutoresList!.count {
                    if instr.id == self.instrutoresList![index].id {
                        self.instrutorPickerView.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                }
            }
        })
    }
    
    private func prepareHorarioTextField() {
        let toolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: 44.0))
        toolbar.tintColor = UIColor(named: "main")
        toolbar.backgroundColor = .white
        
        let btn_cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(cancelPickerView))
        let btn_done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePickerView))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [btn_cancel, flexSpace, btn_done]
        
        if aula != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            if let time = dateFormatter.date(from: aula!.horarioInicio) { timePickerView.date = time }
        }
        field_horarioInicio.inputView = timePickerView // exibe pickerView ao inves de teclado para o textField
        field_horarioInicio.inputAccessoryView = toolbar
        
        field_horarioFim.inputView = timePickerView
        field_horarioFim.inputAccessoryView = toolbar
    }
    
    private func prepareInstrutorTextField() {
        let toolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: 44.0))
        toolbar.tintColor = UIColor(named: "main")
        toolbar.backgroundColor = .white
        
        let btn_cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(cancelPickerView))
        let btn_done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePickerView))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [btn_cancel, flexSpace, btn_done]
        
        field_instrutor.inputView = instrutorPickerView // exibe pickerView ao inves de teclado para o textField
        field_instrutor.inputAccessoryView = toolbar
    }
    
    @objc func cancelPickerView() {
        if field_horarioInicio.isFirstResponder {
            field_horarioInicio.resignFirstResponder()
        } else if field_horarioFim.isFirstResponder {
            field_horarioFim.resignFirstResponder()
        } else if field_instrutor.isFirstResponder {
            field_instrutor.resignFirstResponder()
        }
    }
    
    @objc func donePickerView() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        if field_horarioInicio.isFirstResponder {
            field_horarioInicio.text = dateFormatter.string(from: timePickerView.date)
            field_horarioInicio.resignFirstResponder()
        } else if field_horarioFim.isFirstResponder {
            field_horarioFim.text = dateFormatter.string(from: timePickerView.date)
            field_horarioFim.resignFirstResponder()
        } else if field_instrutor.isFirstResponder {
            instrutor = instrutoresList?[instrutorPickerView.selectedRow(inComponent: 0)]
            field_instrutor.text = instrutor?.nome
            field_instrutor.resignFirstResponder()
        }
    }
    
    func getWeekDays(_ selectedDays: [String]) {
        field_diasDaSemana.text = selectedDays.joined(separator: ", ")
    }
    
    private func showSuccessFailAlert(success: Bool, error: String = "Falha ao armazenar dados no servidor!", message: String? = nil) {
        let successMessage = message ?? "Dados foram armazenados com sucesso!"
        
        if success {
            let alert = UIAlertController(title: "SUCESSO", message: successMessage, preferredStyle: .alert)
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
        btn_delete.isEnabled = true
    }
    
    private func proceedToDelete() {
        dbManager.deleteData(aula) { (success) in
            DispatchQueue.main.async {
                self.showSuccessFailAlert(success: success, message: "Dados foram deletados com sucesso!")
            }
        }
    }
    
    
    
    /**********************************************
                MARK: Button Actions
     **********************************************/
    
    @IBAction func showWeekDaysScreen(_ sender: UIButton) {
        let weekDaysPickerScreen = storyboard?.instantiateViewController(withIdentifier: "WeekDaysViewController") as! WeekDaysViewController
        weekDaysPickerScreen.modalPresentationStyle = .overCurrentContext
        weekDaysPickerScreen.delegate = self
        
        // Envia os dias já selecionados, se houver
        weekDaysPickerScreen.presentDays = field_diasDaSemana.text?.components(separatedBy: ", ") ?? []
        
        present(weekDaysPickerScreen, animated: true, completion: nil)
    }
    
    @IBAction func saveData(_ sender: UIButton) {
        sender.isEnabled = false
        btn_delete.isEnabled = false
        var success: Bool
        var dataValidationError: String
        
        if aula == nil {
            // Cria nova Aula
            print("Criando nova Aula")
            
            aula = Aula(field_nome.text!, from: field_horarioInicio.text!, to: field_horarioFim.text!, on: field_diasDaSemana.text!.replacingOccurrences(of: ", ", with: ","), sala: field_sala.text!, by: instrutor)
            (success, dataValidationError) = dbManager.uploadData(aula, mode: .add, onComplete: { (success) in
                DispatchQueue.main.async {
                    self.showSuccessFailAlert(success: success)
                    if !success { self.aula = nil }
                }
            })
            
            /* Se houver erro de conformidade ao criar uma nova aula,
             * a reseta para que a considere uma nova aula novamente na próxima vez que a salvar,
             * caso contrario seria consderado uma aula já existente, e chamaria a funcão de update
             * mesmo que ainda não possuísse um id configurado
             */
            if !success { aula = nil }
        } else {
            // Editando dados de uma Aula
            print("Tentando salvar a edição da Aula: \(aula!.nome)")
            
            aula!.update(field_nome.text!, from: field_horarioInicio.text!, to: field_horarioFim.text!, on: field_diasDaSemana.text!.replacingOccurrences(of: ", ", with: ","), sala: field_sala.text!, by: instrutor)
            (success, dataValidationError) = dbManager.uploadData(aula, mode: .update, onComplete: { (success) in
                DispatchQueue.main.async { self.showSuccessFailAlert(success: success) }
            })
        }
        
        if !success { showSuccessFailAlert(success: success, error: dataValidationError) }
    }
    
    @IBAction func closeScreen(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteAula(_ sender: UIButton) {
        let deleteMessage = "Tem certeza que deseja excluir a Aula:\n\"\(aula!.nome)\"?"
        
        // Exibe Alerta de Confirmação da deleção
        let deleteAlert = UIAlertController(title: "Confirme Deleção", message: deleteMessage, preferredStyle: .alert)
        let btn_cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        let btn_confirm = UIAlertAction(title: "Sim", style: .default) { (nil) in
            self.proceedToDelete()
        }
        deleteAlert.addAction(btn_cancel)
        deleteAlert.addAction(btn_confirm)
        present(deleteAlert, animated: true, completion: nil)
    }
}



    /**********************************************
        MARK: Métodos de Controle do PickerView
    **********************************************/

extension AddEditAulaViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return instrutoresList?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return instrutoresList?[row].nome
    }
}
