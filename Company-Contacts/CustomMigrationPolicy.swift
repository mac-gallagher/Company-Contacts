//
//  CustomMigrationPolicy.swift
//  Company-Contacts
//
//  Created by Mac Gallagher on 3/5/18.
//  Copyright © 2018 Mac Gallagher. All rights reserved.
//

import CoreData

class CustomMigrationPolicy: NSEntityMigrationPolicy {
    
    @objc func transformNumEmployees(forNum: Int16) -> String {
        if forNum < 150 {
            return "small"
        } else {
            return "very large"
        }
    }
}
