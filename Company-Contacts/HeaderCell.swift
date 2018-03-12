//
//  CompanyHeaderCell.swift
//  Company-Contacts
//
//  Created by Mac Gallagher on 3/5/18.
//  Copyright © 2018 Mac Gallagher. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewCell {
    
    let userIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.darkBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(title: String, icon: UIImage, imageFrame: CGRect, style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        userIcon.image = icon
        nameLabel.text = title
        
        backgroundColor = .lightBlue
        
        addSubview(userIcon)
        userIcon.heightAnchor.constraint(equalToConstant: imageFrame.height).isActive = true
        userIcon.widthAnchor.constraint(equalToConstant: imageFrame.width).isActive = true
        userIcon.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        userIcon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(nameLabel)
        nameLabel.leftAnchor.constraint(equalTo: userIcon.rightAnchor, constant: 16).isActive = true
        nameLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
