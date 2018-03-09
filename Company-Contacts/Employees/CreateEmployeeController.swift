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

class CreateEmployeeController: UIViewController, UITextFieldDelegate {
    
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
    
    var saveButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        navigationItem.rightBarButtonItem = saveButton
        birthdayTextField.delegate = self
        nameTextField.autocorrectionType = .no
        nameTextField.delegate = self
        nameTextField.addTarget(self, action: #selector(nameFieldDidChange), for: UIControlEvents.editingChanged)
        birthdayTextField.keyboardType = .numbersAndPunctuation
        birthdayTextField.autocorrectionType = .no
        
        nameFieldDidChange()
        setupUI()
    }
    
    @objc private func handleSave() {
        guard let employeeName = nameTextField.text else { return }
        guard let company = company else { return }
        guard let birthdayText = birthdayTextField.text else { return }
        
        if birthdayText.isEmpty {
            showError(title: "Add Birthday", message: "Please enter a birthday.")
            return
        }
        
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 10
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    @objc private func nameFieldDidChange() {
        if nameTextField.text == "" {
            saveButton?.isEnabled = false
        } else {
            saveButton?.isEnabled = true
        }
    }
    
    private func showError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
}
