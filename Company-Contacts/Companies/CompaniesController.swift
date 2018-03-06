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
    
    @objc private func doWork() {
        print("Trying to do work...")
        
        CoreDataManager.shared.persistentContainer.performBackgroundTask({ (backgroundContext) in
            
            (0...5).forEach { (value) in
                print(value)
                let company = Company(context: backgroundContext)
                company.name = String(value)
            }
            do {
                try backgroundContext.save()
                
                DispatchQueue.main.async {
                    self.companies = CoreDataManager.shared.fetchCompanies()
                    self.tableView.reloadData()
                }
                
                
            } catch let err{
                print("Failed to save:", err)
            }
            
        })
        
        //GCD - Grand Cerntal Dispatch
        
        DispatchQueue.global(qos: .background).async {
            
        }
    }
    
    @objc private func doUpdates() {
        print("Trying to update companies on a background context")
        
        CoreDataManager.shared.persistentContainer.performBackgroundTask { (backgroundContext) in
            
            let request: NSFetchRequest<Company> = Company.fetchRequest()
            
            do {
                let companies = try backgroundContext.fetch(request)
                
                companies.forEach({ (company) in
                    print(company.name ?? "")
                    company.name = "C: \(company.name ?? "")"
                })
                
                do {
                    try backgroundContext.save()
                    
                    DispatchQueue.main.async {
                        CoreDataManager.shared.persistentContainer.viewContext.reset()
                        
                        //this resets EVERYTHING. Can we merge just our changes?
                        
                        
                        self.companies = CoreDataManager.shared.fetchCompanies()
                        self.tableView.reloadData()
                    }
                    
                } catch let saveErr{
                    print("Failed to save on background:", saveErr)
                }
                
            } catch let err {
                print("Failed to catch companies on backgrounf thread:", err)
            }
        }
    }
    
    @objc private func doNestedUpdates() {
        print("Trying to perform nested updates...")
        
        DispatchQueue.global(qos: .background).async {
            
            let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            
            privateContext.parent = CoreDataManager.shared.persistentContainer.viewContext
            
            //execute updates on private context
            
            let request: NSFetchRequest<Company> = Company.fetchRequest()
            request.fetchLimit = 1
            
            do {
                
                let companies = try privateContext.fetch(request)
        
                companies.forEach({ (company) in
                    company.name = "D: \(company.name ?? "")"
                })
                
                do {
                    try privateContext.save()
                    
                    DispatchQueue.main.async {
                        
                        do {
                            
                            let context = CoreDataManager.shared.persistentContainer.viewContext
                            
                            if context.hasChanges {
                                try context.save()
                            }
                            
                            self.tableView.reloadData()
                            
                        } catch let finalSaveError{
                            print(finalSaveError)
                        }
                        
                    }
                    
                } catch let saveErr{
                    print("Failed to save on private context:", saveErr)
                }
                
            } catch let fetchErr {
                print("Failed to fetch on private context:", fetchErr)
            }
            
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        companies = CoreDataManager.shared.fetchCompanies()
        
        view.backgroundColor = .white
        
        tableView.backgroundColor = .darkBlue
        tableView.separatorColor = .white
        tableView.tableFooterView = UIView()
        tableView.register(CompanyCell.self, forCellReuseIdentifier: "cellId")
        
        navigationItem.title = "Companies"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: #selector(handleAddCompany))
        
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(title: "Reset", style: .plain
            , target: self, action: #selector(handleReset)),
            UIBarButtonItem(title: "Nested Updates", style: .plain
                , target: self, action: #selector(doNestedUpdates))
        ]
        
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
        let createCompanyController = CreateCompanyController()
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        createCompanyController.delegate = self
        present(navController, animated: true, completion: nil)
    }
    
}






