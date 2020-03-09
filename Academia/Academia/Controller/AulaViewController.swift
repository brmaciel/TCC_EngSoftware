//
//  AulaViewController.swift
//  Academia
//
//  Created by Bruno Maciel on 8/26/19.
//  Copyright © 2019 Bruno Maciel. All rights reserved.
//

import UIKit

class AulaViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var field_nome: UITextField!
    @IBOutlet weak var field_instrutor: UITextField!
    @IBOutlet weak var field_diasDaSemana: UITextField!
    @IBOutlet weak var field_horario: UITextField!
    @IBOutlet weak var field_sala: UITextField!
    @IBOutlet weak var aulaTableView: UITableView!
    
    
    // MARK: Properties
    var aulasList: [Aula]?
    let dbManager = DBManager.singleton
    
    
    // MARK: UI Elements
    lazy var timePickerView: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.backgroundColor = .white
        return datePicker
    }()
    
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

        aulaTableView.backgroundView = lb_emptyTableView
        prepareTimeTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        aulasList = nil
        aulaTableView.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // Vai para a 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editAulaSegue" {
            let vc = segue.destination as! AddEditAulaViewController
            
            let aula = aulasList?[aulaTableView.indexPathForSelectedRow!.row]
            vc.aula = aula
        }
    }
    
    
    
    /**********************************************
                    MARK: Methods
     **********************************************/
    
    func prepareTimeTextField() {
        let toolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: 44.0))
        toolbar.tintColor = UIColor(named: "main")
        toolbar.backgroundColor = .white
        
        let btn_cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(cancelPickerView))
        let btn_done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePickerView))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [btn_cancel, flexSpace, btn_done]
        
        field_horario.inputView = timePickerView
        field_horario.inputAccessoryView = toolbar
    }
    
    @objc func cancelPickerView() {
        field_horario.resignFirstResponder()
    }
    
    @objc func donePickerView() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        field_horario.text = dateFormatter.string(from: timePickerView.date)
        field_horario.resignFirstResponder()
    }
    
    func getWeekDays(_ selectedDays: [String]) {
        field_diasDaSemana.text = selectedDays.joined(separator: ", ")
    }
    
    
    
    /**********************************************
                MARK: Button Actions
     **********************************************/

    @IBAction func searchAula(_ sender: UIButton) {
        let searchValues = [field_nome.text!, field_instrutor.text!, field_diasDaSemana.text!, field_horario.text!, field_sala.text!]
        dbManager.searchForAula(with: searchValues) { (aulas) in
            self.aulasList = aulas
            DispatchQueue.main.async {
                self.aulaTableView.reloadData()
            }
        }
        view.endEditing(true)
    }
    
    @IBAction func showWeekDaysScreen(_ sender: UIButton) {
        let weekDaysPickerScreen = storyboard?.instantiateViewController(withIdentifier: "WeekDaysViewController") as! WeekDaysViewController
        weekDaysPickerScreen.modalPresentationStyle = .overCurrentContext
        weekDaysPickerScreen.delegate2 = self
        
        // Envia os dias já selecionados, se houver
        weekDaysPickerScreen.presentDays = field_diasDaSemana.text?.components(separatedBy: ", ") ?? []
        
        present(weekDaysPickerScreen, animated: true, completion: nil)
    }
}



    /**********************************************
         MARK: Métodos de Controle do TableView
     **********************************************/

extension AulaViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let nCells = aulasList?.count else {
            lb_emptyTableView.text = "Realize uma busca"
            aulaTableView.backgroundView = lb_emptyTableView
            return 0
        }
        
        if nCells == 0 {
            lb_emptyTableView.text = "Nenhum resultado encontrado"
            aulaTableView.backgroundView = lb_emptyTableView
        } else {
            aulaTableView.backgroundView = nil
        }
        
        return nCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCell", for: indexPath) as! AulaTableViewCell
        
        // configure cell
        guard let aula = aulasList?[indexPath.row] else { return cell }
        cell.prepareCell(with: aula)
        
        return cell
    }
}
