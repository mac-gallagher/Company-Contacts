//
//  ViewController.swift
//  Company-Contacts
//
//  Created by Mac Gallagher on 2/26/18.
//  Copyright © 2018 Mac Gallagher. All rights reserved.
//

import UIKit

class CompaniesController: UITableViewController, CreateCompanyControllerDelegate {
   
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
        if companies.count > 0 {
            let alertController = UIAlertController(title: "Delete All Companies", message: "Are you sure you want to remove all companies from the list? This action cannot be undone.", preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "Delete All", style: .destructive) { (action) in
                do {
                    try CoreDataManager.shared.deleteAllCompanies {
                        var indexPathsToRemove = [IndexPath]()
                        for (index, _) in self.companies.enumerated() {
                            indexPathsToRemove.append(IndexPath(row: index, section: 0))
                        }
                        self.companies.removeAll()
                        self.tableView.deleteRows(at: indexPathsToRemove, with: .left)
                    }
                } catch let deleteError {
                    print("Unable to delete companies from Core Data:", deleteError)
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc func handleAddCompany() {
        let createCompanyController = CreateCompanyController()
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        createCompanyController.delegate = self
        present(navController, animated: true, completion: nil)
    }
    
    func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = "Companies"
        tableView.backgroundColor = .darkBlue
        tableView.separatorColor = UIColor.lightBlue
        tableView.tableFooterView = UIView()
    }
    
    func didAddCompany(company: Company) {
        companies.append(company)
        let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    func didEditCompany(company: Company) {
        let row = companies.index(of: company)
        let reloadIndexPath = IndexPath(row: row!, section: 0)
        tableView.reloadRows(at: [reloadIndexPath], with: .middle)
    }
    
}






