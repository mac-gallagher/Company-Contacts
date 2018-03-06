//
//  CoreDataManager.swift
//  Company-Contacts
//
//  Created by Mac Gallagher on 2/27/18.
//  Copyright © 2018 Mac Gallagher. All rights reserved.
//

import CoreData
import UIKit

struct CoreDataManager {
    
    static let shared = CoreDataManager() // will live forever as long as application is still running, its properties will too
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { (storeDescription, err) in
            if let err = err {
                fatalError("Loading of store failed: \(err)")
            }
        }
        return container
    }()
    
    func fetchCompanies() throws -> [Company] {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        do {
            let companies = try context.fetch(fetchRequest)
            return companies
        } catch {
            throw error
        }
    }
    
    func createCompany(companyName: String, foundedDate: Date, companyImage: UIImage) throws -> Company {
        let context = persistentContainer.viewContext
        let company = Company(context: context)
        company.name = companyName
        company.founded = foundedDate
    
        let imageData = UIImageJPEGRepresentation(companyImage, 0.8)
        company.imageData = imageData
        
        do {
            try context.save()
            return company
        } catch {
            throw error
        }
    }
    
    func updateCompany(company: Company, completion: () -> ()) throws {
        let context = persistentContainer.viewContext
        do {
            try context.save()
            completion()
        } catch {
            throw error
        }
    }
    
    func deleteCompany(company: Company, completion: () -> ()) throws {
        let context = persistentContainer.viewContext
        context.delete(company)
        do {
            try context.save()
            completion()
        } catch {
            throw error
        }
    }
    
    func deleteAllCompanies(completion: () -> ()) throws {
        let context = persistentContainer.viewContext
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
        do {
            try context.execute(batchDeleteRequest)
            completion()
        } catch {
            throw error
        }
    }
    
    func createEmployee(employeeName: String, employeeType: String, company: Company, birthday: Date) throws -> Employee {
        let context = persistentContainer.viewContext
        
        let employee = Employee(context: context)
        employee.company = company
        employee.type = employeeType
        employee.name = employeeName
        
        let employeeInformation = EmployeeInformation(context: context)
        employee.employeeInformation = employeeInformation
        employee.employeeInformation?.birthday = birthday
        
        do {
            try context.save()
            return employee
        } catch {
            throw error
        }
    }
    
    
}
