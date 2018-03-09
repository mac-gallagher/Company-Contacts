//
//  ViewController.swift
//  Company-Contacts
//
//  Created by Mac Gallagher on 2/26/18.
//  Copyright © 2018 Mac Gallagher. All rights reserved.
//

import UIKit

class CompaniesController: UITableViewController {
   
    var companies = [Company]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            companies = try CoreDataManager.shared.fetchCompanies()
        } catch let fetchError {
            print("Failed to fetch companies from Core Data:", fetchError)
        }
        setupPlusButtonInNavBar(selector: #selector(handleAddCompany))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain
            , target: self, action: #selector(handleReset))
        tableView.register(CompanyCell.self, forCellReuseIdentifier: "cellId")
        
        setupUI()
    }

    @objc private func handleReset() {
        do {
            try CoreDataManager.shared.deleteAllCompanies {
                var indexPathsToRemove = [IndexPath]()
                for (index, _) in companies.enumerated() {
                    indexPathsToRemove.append(IndexPath(row: index, section: 0))
                }
                companies.removeAll()
                tableView.deleteRows(at: indexPathsToRemove, with: .left)
            }
        } catch let deleteError {
            print("Unable to delete companies from Core Data:", deleteError)
        }
    }
    
    @objc func handleAddCompany() {
        let createCompanyController = CreateCompanyController()
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        createCompanyController.delegate = self
        present(navController, animated: true, completion: nil)
    }
    
}






