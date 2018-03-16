//
//  ViewController.swift
//  Company-Contacts
//
//  Created by Mac Gallagher on 2/26/18.
//  Copyright © 2018 Mac Gallagher. All rights reserved.
//
////////////////////////////////////////////////
// TO DO
////////////////////////////////////////////////
//
// - Bug fix: If a name is changed and subsequently needs to be reordered, the order changes but not the name
// - Custom date picker
// - For JSON companies, load and cache images using SDWebImage
// - Fix refresh control in companies tableView
// - Bug fix: JSON Apple company does not get removed from Core Data for some reason (maybe do batch update instead?)
//

import UIKit
import CoreData
class CompaniesController: UITableViewController {
   
    let fetchedCompaniesController: NSFetchedResultsController<Company> = {
        let request: NSFetchRequest<Company> = Company.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
        request.sortDescriptors = [sortDescriptor]
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
        view.backgroundColor = .white
        navigationItem.title = "Companies"
        tableView.backgroundColor = .darkBlue
        tableView.separatorColor = UIColor.lightBlue
        if tableView.numberOfRows(inSection: 0) == 0 {
            setupEmptyTableFooter(animate: false)
        } else {
            tableView.tableFooterView = UIView()
        }
        fetchedCompaniesController.delegate = self
        setupPlusButtonInNavBar(selector: #selector(handleAddCompany))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain
            , target: self, action: #selector(handleReset))
        tableView.register(CompanyCell.self, forCellReuseIdentifier: "cellId")
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        refreshControl.tintColor = .white
        self.refreshControl = refreshControl
    }
    
    @objc private func handleRefresh() {
        Service.shared.downloadCompaniesFromServer() {
            self.refreshControl?.endRefreshing()
        }
    }

    @objc private func handleReset() {
        guard let companies = fetchedCompaniesController.fetchedObjects else { return }
        if companies.count > 0 {
            let alertController = UIAlertController(title: "Delete All Companies", message: "Are you sure you want to remove all companies? This action cannot be undone.", preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "Delete All", style: .destructive) { (_) in
                do {
                    try CoreDataManager.shared.deleteAllCompanies {
                        do {
                            try self.fetchedCompaniesController.performFetch()
                            var indexPathsToRemove = [IndexPath]()
                            for (index, _) in companies.enumerated() {
                                indexPathsToRemove.append(IndexPath(row: index, section: 0))
                            }
                            self.tableView.deleteRows(at: indexPathsToRemove, with: .left)
                            self.setupEmptyTableFooter(animate: true)
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
    
}






