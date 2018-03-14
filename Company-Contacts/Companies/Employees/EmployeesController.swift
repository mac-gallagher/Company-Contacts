//
//  EmployeesController.swift
//  Company-Contacts
//
//  Created by Mac Gallagher on 3/2/18.
//  Copyright © 2018 Mac Gallagher. All rights reserved.
//

import UIKit
import CoreData

class EmployeesController: UITableViewController {
    
    var company: Company?
    let cellId = "cellId"
    
    lazy var fetchedEmployeesController: NSFetchedResultsController<Employee> = {
        let request: NSFetchRequest<Employee> = Employee.fetchRequest()
        if let company = company {
            request.predicate = NSPredicate(format: "self.company == %@", company)
        }
        let primarySortDescriptor = NSSortDescriptor(key: "type", ascending: true)
        let secondarySortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [primarySortDescriptor, secondarySortDescriptor]
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.shared.context, sectionNameKeyPath: "type", cacheName: nil)
        do {
            try frc.performFetch()
        } catch let fetchError {
            print("Failed to fetch employees from persistent store:", fetchError)
        }
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchedEmployeesController.delegate = self
        tableView.backgroundColor = UIColor.darkBlue
        tableView.tableFooterView = UIView()
        tableView.register(EmployeeCell.self, forCellReuseIdentifier: cellId)
        setupPlusButtonInNavBar(selector: #selector(handleAdd))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = company?.name
    }
    
    @objc private func handleAdd() {
        let createEmployeeController = CreateEmployeeController()
        createEmployeeController.company = company
        let navController = UINavigationController(rootViewController: createEmployeeController)
        present(navController, animated: true, completion: nil)
    }
}
