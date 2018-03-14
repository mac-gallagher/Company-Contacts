//
//  Footer.swift
//  Company-Contacts
//
//  Created by Mac Gallagher on 3/12/18.
//  Copyright © 2018 Mac Gallagher. All rights reserved.
//

import UIKit

class EmptyTableView: UIView {
    
    var topLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    var bottomLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpperText(text: String) {
        let attributes = [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue]
        let attributedText = NSMutableAttributedString(string: "\(text)", attributes: attributes)
        topLabel.attributedText = attributedText
    }
    
    func setLowerText(lines: [String]) {
        bottomLabel.text = "\(lines[0])\n\(lines[1])"
    }
    
    
    func setupViews() {
        addSubview(topLabel)
        addSubview(bottomLabel)
        
        topLabel.topAnchor.constraint(equalTo: topAnchor, constant: 55).isActive = true
        topLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        bottomLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        bottomLabel.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 40).isActive = true
        
    }
}
