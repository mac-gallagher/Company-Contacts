//
//  CreateCompanyController.swift
//  Company-Contacts
//
//  Created by Mac Gallagher on 2/26/18.
//  Copyright © 2018 Mac Gallagher. All rights reserved.
//

import UIKit

class CreateCompanyController: UIViewController, UITextFieldDelegate {
    
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
    
    let companyImageView = UIImageView(image: #imageLiteral(resourceName: "empty_photo"))
    let selectImageButton = UIButton(type: .system)
    let nameLabel = UILabel()
    let dateLabel = UILabel()
    let foundedLabel = UILabel()
    let nameTextField = UITextField()
    let datePicker = UIDatePicker()
    
    var saveButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        navigationItem.rightBarButtonItem = saveButton
        selectImageButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto)))
        datePicker.addTarget(self, action: #selector(dateDidChange), for: UIControlEvents.valueChanged)
        datePicker.maximumDate = Date()
        nameTextField.addTarget(self, action: #selector(nameFieldDidChange), for: UIControlEvents.editingChanged)
        nameTextField.delegate = self
        nameTextField.autocorrectionType = .no
        
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
        guard let name = nameTextField.text else { return }
        if CoreDataManager.shared.containsCompany(with: name) {
            presentDuplicateCompanyError()
            return
        }
        view.endEditing(true)
        if company == nil {
            dismiss(animated: true) {
                self.createCompany()
            }
        } else {
            dismiss(animated: true) {
                self.saveCompanyChanges()
            }
        }
    }
    
    private func presentDuplicateCompanyError() {
        let alert = UIAlertController(title: "Company Already Exists", message: "Please enter another name.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func handleCancel() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
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
            try CoreDataManager.shared.createCompany(companyName: name, foundedDate: self.datePicker.date, imageData: imageData)
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
            try CoreDataManager.shared.saveCompanies()
        } catch let saveError {
            print("Failed to update company changes:", saveError)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        datePicker.isUserInteractionEnabled = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameTextField.endEditing(true)
        datePicker.isUserInteractionEnabled = true
    }

}

extension CreateCompanyController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            companyImageView.image = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            companyImageView.image = originalImage
        }
        setupCircularImageStyle()
        dismiss(animated: true, completion: nil)
    }
    
}
