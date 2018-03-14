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
   
    let fetchedCompaniesController: NSFetchedResultsController<Company> = {
        let request: NSFetchRequest<Company> = Company.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.shared.context, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try frc.performFetch()
        } catch let fetchError {
            print("Failed to fetch companies from persistent store:", fetchError)
        }
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchedCompaniesController.delegate = self
        setupPlusButtonInNavBar(selector: #selector(handleAddCompany))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain
            , target: self, action: #selector(handleReset))
        tableView.register(CompanyCell.self, forCellReuseIdentifier: "cellId")
        setupUI()
    }

    @objc private func handleReset() {
        guard let companies = fetchedCompaniesController.fetchedObjects else { return }
        if companies.count > 0 {
            let alertController = UIAlertController(title: "Delete All Companies", message: "Are you sure you want to remove all companies from the list? This action cannot be undone.", preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "Delete All", style: .destructive) { (_) in
                do {
                    try CoreDataManager.shared.deleteAllCompanies {
                        do {
                            try self.fetchedCompaniesController.performFetch()
                            var indexPathsToRemove = [IndexPath]()
                            for (index, _) in companies.enumerated() {
                                indexPathsToRemove.append(IndexPath(row: index, section: 0))
                            }
                            self.tableView.deleteRows(at: indexPathsToRemove, with: .fade)
                        } catch let fetchError {
                            print("Failed to fetch companies from persistent store:", fetchError)
                        }
                    }
                } catch let deleteError {
                    print("Failed to batch delete companies from persistent store:", deleteError)
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
        present(navController, animated: true, completion: nil)
    }
    
    func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = "Companies"
        tableView.backgroundColor = .darkBlue
        tableView.separatorColor = UIColor.lightBlue
        tableView.tableFooterView = UIView()
    }
}






