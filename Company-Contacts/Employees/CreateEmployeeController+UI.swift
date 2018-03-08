//
//  CreateEmployeeController+UI.swift
//  Company-Contacts
//
//  Created by Mac Gallagher on 3/6/18.
//  Copyright © 2018 Mac Gallagher. All rights reserved.
//

import UIKit

extension CreateEmployeeController {
    
    func setupUI() {
        view.backgroundColor = .darkBlue
        navigationItem.title = "Create Employee"
        
        _ = setupLightBlueBackgroundView(height: 150)
    
        nameLabel.text = "Name"
       
        nameTextField.placeholder = "Enter name"
      
        birthdayLabel.text = "Birthday"
       
        birthdayTextField.placeholder = "MM/dd/yyyy"
      
        employeeTypeSegmentedControl.selectedSegmentIndex = 0
        employeeTypeSegmentedControl.tintColor = UIColor.darkBlue
      
        setupCancelButton()
        performAutoLayout()
    }
    
    func performAutoLayout() {
        view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(nameTextField)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor, constant: 8).isActive = true
        
        view.addSubview(birthdayLabel)
        birthdayLabel.translatesAutoresizingMaskIntoConstraints = false
        birthdayLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        birthdayLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        birthdayLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        birthdayLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(birthdayTextField)
        birthdayTextField.translatesAutoresizingMaskIntoConstraints = false
        birthdayTextField.leftAnchor.constraint(equalTo: birthdayLabel.rightAnchor).isActive = true
        birthdayTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        birthdayTextField.bottomAnchor.constraint(equalTo: birthdayLabel.bottomAnchor).isActive = true
        birthdayTextField.topAnchor.constraint(equalTo: birthdayLabel.topAnchor).isActive = true
        
        view.addSubview(employeeTypeSegmentedControl)
        employeeTypeSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        employeeTypeSegmentedControl.topAnchor.constraint(equalTo: birthdayLabel.bottomAnchor, constant: 8).isActive = true
        employeeTypeSegmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        employeeTypeSegmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        employeeTypeSegmentedControl.heightAnchor.constraint(equalToConstant: 34).isActive = true
    }
    
    
    
    
    
}
