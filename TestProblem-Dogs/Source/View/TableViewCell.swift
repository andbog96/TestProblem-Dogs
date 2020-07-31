//
//  TableViewCell.swift
//  TestProblem-Dogs
//
//  Created by Andrey Bogdanov on 30.07.2020.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "TableViewCell"
    
    private static let labelsFontSizeDifference: CGFloat = 3
    private let spacing: CGFloat = 16

    let firstLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var secondLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.secondaryLabel
        label.font = label.font.withSize(label.font.pointSize - labelsFontSizeDifference)
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(firstLabel)
        addSubview(secondLabel)
        
        firstLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: spacing).isActive = true
        firstLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        secondLabel.leadingAnchor.constraint(equalTo: firstLabel.trailingAnchor, constant: spacing).isActive = true
        secondLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        accessoryType = .none
        firstLabel.text = ""
        secondLabel.text = ""
    }
}
