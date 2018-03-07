//
//  CreateEmployeeController.swift
//  Company-Contacts
//
//  Created by Mac Gallagher on 3/2/18.
//  Copyright © 2018 Mac Gallagher. All rights reserved.
//

import UIKit

protocol CreateEmployeeControllerDelegate {
    func didAddEmployee(employee: Employee)
}

class CreateEmployeeController: UIViewController {
    
    var company: Company?
    
    var delegate: CreateEmployeeControllerDelegate?
    
    let nameLabel = UILabel()
    let nameTextField = UITextField()
    let birthdayLabel = UILabel()
    let birthdayTextField = UITextField()
    let employeeTypeSegmentedControl = UISegmentedControl(items:
        [EmployeeType.Executive.rawValue,
        EmployeeType.SeniorManagement.rawValue,
        EmployeeType.Staff.rawValue])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        setupUI()
    }
    
    @objc private func handleSave() {
        guard let employeeName = nameTextField.text else { return }
        guard let company = company else { return }
        guard let birthdayText = birthdayTextField.text else { return }
        
        performFormValidation(birthdayText: birthdayText, employeeName: employeeName)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        guard let birthdayDate = dateFormatter.date(from: birthdayText) else {
            showError(title: "Invalid Birthday", message: "Please enter a valid birthday.")
            return
        }
        
        guard let employeeType = employeeTypeSegmentedControl.titleForSegment(at: employeeTypeSegmentedControl.selectedSegmentIndex) else { return }
        
        do {
            let employee = try CoreDataManager.shared.createEmployee(employeeName: employeeName, employeeType: employeeType, company: company, birthday: birthdayDate)
            dismiss(animated: true) {
                self.delegate?.didAddEmployee(employee: employee)
            }
        } catch {
            print("Failed to create employee in Core Data: ", error)
        }
    }
    
    private func showError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func performFormValidation(birthdayText: String, employeeName: String) {
        if birthdayText.isEmpty {
            showError(title: "Add Birthday", message: "Please enter a birthday.")
            return
        }
    }
    
    
    
    
    
}
