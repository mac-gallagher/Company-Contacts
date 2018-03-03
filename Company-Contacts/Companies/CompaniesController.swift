//
//  ViewController.swift
//  Company-Contacts
//
//  Created by Mac Gallagher on 2/26/18.
//  Copyright © 2018 Mac Gallagher. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController {
   
    var companies = [Company]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        companies = CoreDataManager.shared.fetchCompanies()
        
        view.backgroundColor = .white
        
        tableView.backgroundColor = .darkBlue
        tableView.separatorColor = .white
        tableView.tableFooterView = UIView()
        tableView.register(CompanyCell.self, forCellReuseIdentifier: "cellId")
        
        navigationItem.title = "Companies"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal), style: .plain
            , target: self, action: #selector(handleAddCompany))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain
            , target: self, action: #selector(handleReset))
    }


    @objc private func handleReset() {
        CoreDataManager.shared.deleteAllCompanies { (error) in
            if error != nil {
                // maybe show a user-frendly messsage here...
            } else {
                var indexPathsToRemove = [IndexPath]()
                for (index, _) in companies.enumerated() {
                    indexPathsToRemove.append(IndexPath(row: index, section: 0))
                }
                companies.removeAll()
                tableView.deleteRows(at: indexPathsToRemove, with: .left)
            }
        }
    }
    
    @objc func handleAddCompany() {
        print("Adding company...")
        
        let createCompanyController = CreateCompanyController()
        
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        
        createCompanyController.delegate = self
        
        present(navController, animated: true, completion: nil)
    }
    
}






