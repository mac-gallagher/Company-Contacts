//
//  CreateCompanyController+UI.swift
//  Company-Contacts
//
//  Created by Mac Gallagher on 3/5/18.
//  Copyright © 2018 Mac Gallagher. All rights reserved.
//

import UIKit

extension CreateCompanyController {
    
    func setupUI() {
        view.backgroundColor = .darkBlue
        
        _ = setupLightBlueBackgroundView(height: 425)
        
        nameLabel.text = "Name"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.textColor = UIColor.darkBlue
        
        foundedLabel.text = "Founded"
        foundedLabel.font = UIFont.boldSystemFont(ofSize: 16)
        foundedLabel.textColor = UIColor.darkBlue
        
        nameTextField.autocapitalizationType = .words
        nameTextField.placeholder = "Enter name"
        nameTextField.textColor = UIColor.darkBlue
        nameTextField.font = UIFont.systemFont(ofSize: 16)
        
        datePicker.datePickerMode = .date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        dateLabel.text = dateFormatter.string(from: datePicker.date)
        dateLabel.textColor = UIColor.darkBlue
        dateLabel.font = UIFont.systemFont(ofSize: 16)
        
        selectImageButton.setTitle("Select Photo", for: .normal)
        selectImageButton.layer.borderWidth = 1
        selectImageButton.layer.borderColor = UIColor.darkBlue.cgColor
        selectImageButton.layer.cornerRadius = 5
        selectImageButton.setTitleColor(UIColor.darkBlue, for: .normal)
        selectImageButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        companyImageView.isUserInteractionEnabled = true
        companyImageView.contentMode = .scaleAspectFill
        
        performAutoLayout()
        setupCircularImageStyle()
    }
    
    func setupCircularImageStyle() {
        companyImageView.layer.cornerRadius = 50
        companyImageView.clipsToBounds = true
        companyImageView.layer.borderColor = UIColor.darkBlue.cgColor
        companyImageView.layer.borderWidth = 1
    }
    
    func performAutoLayout() {
        
        view.addSubview(companyImageView)
        companyImageView.translatesAutoresizingMaskIntoConstraints = false
        companyImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        companyImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        companyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        companyImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.addSubview(selectImageButton)
        selectImageButton.translatesAutoresizingMaskIntoConstraints = false
        selectImageButton.topAnchor.constraint(equalTo: companyImageView.bottomAnchor, constant: 8).isActive = true
        selectImageButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        selectImageButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        selectImageButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: selectImageButton.bottomAnchor, constant: 8).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(nameTextField)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        
        view.addSubview(foundedLabel)
        foundedLabel.translatesAutoresizingMaskIntoConstraints = false
        foundedLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        foundedLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        foundedLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        foundedLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.leftAnchor.constraint(equalTo: foundedLabel.rightAnchor).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: foundedLabel.bottomAnchor).isActive = true
        dateLabel.topAnchor.constraint(equalTo: foundedLabel.topAnchor).isActive = true
       
        view.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.topAnchor.constraint(equalTo: foundedLabel.bottomAnchor, constant: 8).isActive = true
        datePicker.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        datePicker.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        datePicker.heightAnchor.constraint(equalToConstant: 175).isActive = true 
        
    }
    
}
