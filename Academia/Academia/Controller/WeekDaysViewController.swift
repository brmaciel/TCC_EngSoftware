//
//  WeekDaysViewController.swift
//  Academia
//
//  Created by Bruno Maciel on 8/26/19.
//  Copyright © 2019 Bruno Maciel. All rights reserved.
//

import UIKit

class WeekDaysViewController: UIViewController {

    // MARK: Properties
    let weekDays = ["Domingo", "Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado"]
    let weekDaysShort = ["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sab"]
    var selectedDays: [String] = ["", "", "", "", "", "", ""]
    var presentDays: [String] = []
    
    weak var delegate: AddEditAulaViewController?
    weak var delegate2: AulaViewController?
    
    
    
    /**********************************************
                MARK: Override Methods
     **********************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for day in presentDays {
            for (index, day2) in weekDaysShort.enumerated() {
                if day == day2 { selectedDays[index] = weekDays[index] }
            }
        }
    }
    
    
    
    /**********************************************
                    MARK: Methods
     **********************************************/
    
    func transformSelectedDays() -> [String] {
        let daysDict = ["Domingo": "Dom", "Segunda": "Seg", "Terça": "Ter", "Quarta": "Qua", "Quinta": "Qui", "Sexta": "Sex", "Sábado": "Sab"]
        var daysShort: [String] = []
        
        for day in selectedDays {
            if day != "" {
                daysShort.append(daysDict[day] ?? "")
            }
        }
        print(daysShort)
        return daysShort
    }
    
    
    
    /**********************************************
                MARK: Button Actions
     **********************************************/

    @IBAction func closeScreen(_ sender: UIButton) {
        delegate?.getWeekDays(transformSelectedDays())
        delegate2?.getWeekDays(transformSelectedDays())
        
        dismiss(animated: true, completion: nil)
    }
}



    /**********************************************
        MARK: Métodos de Controle do TableView
    **********************************************/

extension WeekDaysViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCell", for: indexPath)
        cell.textLabel?.text = weekDays[indexPath.row]
        
        if selectedDays[indexPath.row] != "" {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)
        
        if selectedCell?.accessoryType != .checkmark {
            selectedCell?.accessoryType = .checkmark
            selectedDays[indexPath.row] = (selectedCell?.textLabel!.text)!
        } else {
            selectedCell?.accessoryType = .none
            selectedDays[indexPath.row] = ""
        }
    }
}
