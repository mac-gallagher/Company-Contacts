//
//  Companies+UI.swift
//  Company-Contacts
//
//  Created by Mac Gallagher on 3/5/18.
//  Copyright © 2018 Mac Gallagher. All rights reserved.
//

import UIKit

extension CompaniesController {
    
    func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = "Companies"
        tableView.backgroundColor = .darkBlue
        tableView.separatorColor = .white
        tableView.tableFooterView = UIView()
    }
    
}
