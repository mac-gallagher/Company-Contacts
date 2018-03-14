//
//  CoreDataManager.swift
//  Company-Contacts
//
//  Created by Mac Gallagher on 2/27/18.
//  Copyright © 2018 Mac Gallagher. All rights reserved.
//

import CoreData

struct CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let context: NSManagedObjectContext = {
        let persistentContainer = NSPersistentContainer(name: "Model")
        persistentContainer.loadPersistentStores { (storeDescription, err) in
            if let err = err {
                fatalError("Loading of store failed: \(err)")
            }
        }
        return persistentContainer.viewContext
    }()
    
    func createCompany(companyName: String, foundedDate: Date, imageData: Data) throws {
        let company = Company(context: context)
        company.name = companyName
        company.founded = foundedDate
        company.imageData = imageData
        do {
            try context.save()
        } catch {
            throw error
        }
    }
    
    func saveCompanies() throws {
        do {
            try context.save()
        } catch {
            throw error
        }
    }
    
    func deleteCompany(company: Company) throws {
        context.delete(company)
        let employeesFetchRequest: NSFetchRequest<NSFetchRequestResult> = Employee.fetchRequest()
            employeesFetchRequest.predicate = NSPredicate(format: "self.company == %@", company)
        let employeesBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: employeesFetchRequest)
        do {
            try context.execute(employeesBatchDeleteRequest)
            try context.save()
        } catch {
            throw error
        }
    }
    
    func deleteAllCompanies(completion: () -> ()) throws {
        let companyBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
        let employeesBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Employee.fetchRequest())
        do {
            try context.execute(companyBatchDeleteRequest)
            try context.execute(employeesBatchDeleteRequest)
            context.reset()
            completion()
        } catch {
            throw error
        }
    }
    
    func createEmployee(employeeName: String, employeeType: String, company: Company, birthday: Date) throws {
        let employee = Employee(context: context)
        employee.company = company
        employee.type = employeeType
        employee.name = employeeName
        employee.birthday = birthday
        
        do {
            try context.save()
        } catch {
            throw error
        }
    }
    
    func deleteEmployee(employee: Employee) throws {
        context.delete(employee)
        do {
            try context.save()
        } catch {
            throw error
        }
    }
    
}





