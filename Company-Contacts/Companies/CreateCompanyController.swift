//
//  CreateCompanyController.swift
//  Company-Contacts
//
//  Created by Mac Gallagher on 2/26/18.
//  Copyright © 2018 Mac Gallagher. All rights reserved.
//

import UIKit

protocol CreateCompanyControllerDelegate {
    func didAddCompany(company: Company)
    func didEditCompany(company: Company)
}

class CreateCompanyController: UIViewController {
    
    var company: Company? {
        didSet {
            nameTextField.text = company?.name
            if let imageData = company?.imageData {
                companyImageView.image = UIImage(data: imageData)
                setupCircularImageStyle()
            }
            guard let founded = company?.founded else { return }
            datePicker.date = founded
        }
    }
    
    var delegate: CreateCompanyControllerDelegate?
    
    let companyImageView = UIImageView(image: #imageLiteral(resourceName: "select_photo_empty"))
    let selectImageButton = UIButton(type: .system)
    let nameLabel = UILabel()
    let dateLabel = UILabel()
    let foundedLabel = UILabel()
    let nameTextField = UITextField()
    let datePicker = UIDatePicker()
    
    var saveButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        navigationItem.rightBarButtonItem = saveButton
        
        selectImageButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto)))
        nameTextField.addTarget(self, action: #selector(nameFieldDidChange), for: UIControlEvents.editingChanged)
        datePicker.addTarget(self, action: #selector(dateDidChange), for: UIControlEvents.valueChanged)
        
        nameFieldDidChange()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = company == nil ? "Create Company" : "Edit Company"
    }
    
    @objc private func handleSelectPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc private func handleSave() {
        if company == nil {
            createCompany()
        } else {
            saveCompanyChanges()
        }
    }
    
    @objc private func dateDidChange() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        dateLabel.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc private func nameFieldDidChange() {
        if nameTextField.text == "" {
            saveButton?.isEnabled = false
        } else {
            saveButton?.isEnabled = true
        }
    }

    private func createCompany() {
        guard
            let name = nameTextField.text,
            let image = companyImageView.image,
            let imageData = UIImageJPEGRepresentation(image, 0.8)
            else { return }
        do {
            let company = try CoreDataManager.shared.createCompany(companyName: name, foundedDate: datePicker.date, imageData: imageData)
            dismiss(animated: true
                , completion: {
                    self.delegate?.didAddCompany(company: company)
            })
        } catch let createError{
            print("Failed to create company in Core Data:", createError)
        }
    }
    
    private func saveCompanyChanges() {
        company!.name = nameTextField.text
        company!.founded = datePicker.date
        
        if let companyImage = companyImageView.image {
            let imageData = UIImageJPEGRepresentation(companyImage, 0.8)
            company?.imageData = imageData
        }
        
        do {
            try CoreDataManager.shared.updateCompany(company: company!, completion: {
                dismiss(animated: true) {
                    self.delegate?.didEditCompany(company: self.company!)
                }
            })
        } catch let saveError {
            print("Failed to save company changes:", saveError)
        }
    }

}
