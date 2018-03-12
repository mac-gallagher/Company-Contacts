//
//  EmployeeCell.swift
//  Company-Contacts
//
//  Created by Mac Gallagher on 3/12/18.
//  Copyright © 2018 Mac Gallagher. All rights reserved.
//

import UIKit

class EmployeeCell: UITableViewCell {
    
    var employee: Employee? {
        didSet {
            nameLabel.text = employee?.name
            if let birthday = employee?.employeeInformation?.birthday {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM dd, yyyy"
                birthdayLabel.text = "\(dateFormatter.string(from: birthday))"
            }
        }
    }
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    var birthdayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .tealColor
        
        addSubview(nameLabel)
        addSubview(birthdayLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 140).isActive = true
        
        birthdayLabel.translatesAutoresizingMaskIntoConstraints = false
        birthdayLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        birthdayLabel.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
    }
    
    
}
