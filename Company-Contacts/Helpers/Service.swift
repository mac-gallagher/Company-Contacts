//
//  Service.swift
//  Company-Contacts
//
//  Created by Mac Gallagher on 3/15/18.
//  Copyright © 2018 Mac Gallagher. All rights reserved.
//

import Foundation
import CoreData

struct Service {
    
    static let shared = Service()
    
    let urlString = "https://api.letsbuildthatapp.com/intermediate_training/companies"
    
    func downloadCompaniesFromServer() {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            
            if let err = err {
                print("Failed to download JSON companies:", err)
                return
            }
            
            guard let data = data else { return }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                let jsonCompanies = try jsonDecoder.decode([JSONCompany].self, from: data)
                
                let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                privateContext.parent = CoreDataManager.shared.context
                
                jsonCompanies.forEach({ (jsonCompany) in
                    let company = Company(context: privateContext)
                    company.name = jsonCompany.name
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                    let foundedDate = dateFormatter.date(from: jsonCompany.founded)
                    company.founded = foundedDate
                    
                    if let photoUrl = URL(string: jsonCompany.photoUrl) {
                        do {
                            let data = try Data(contentsOf: photoUrl)
                            company.imageData = data
                        } catch {
                            print("Failed to download image data for JSON company")
                        }
                    }
                    
                    jsonCompany.employees?.forEach({ (jsonEmployee) in
                        let employee = Employee(context: privateContext)
                        employee.name = jsonEmployee.name
                        employee.type = jsonEmployee.type
                        employee.birthday = dateFormatter.date(from: jsonEmployee.birthday)
                        employee.company = company
                    })
                    
                    do {
                        try privateContext.save()
                        try privateContext.parent?.save()
                    } catch let saveErr{
                        print("Failed to save JSON companies to persistent store:", saveErr)
                    }
                })
                
            } catch let jsonDecodeErr{
                print("Failed to decode JSON companies:", jsonDecodeErr)
            }
            }.resume()
    }
    
}

struct JSONCompany: Decodable {
    let name: String
    let photoUrl: String
    let founded: String
    var employees: [JSONEmployee]?
}

struct JSONEmployee: Decodable {
    let name: String
    let type: String
    let birthday: String
}




