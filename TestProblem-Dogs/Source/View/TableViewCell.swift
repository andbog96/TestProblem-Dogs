//
//  TableViewCell.swift
//  TestProblem-Dogs
//
//  Created by Andrey Bogdanov on 30.07.2020.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "TableViewCell"
    
    private static let labelsFontSizeDifference: CGFloat = 5
    private let spacing: CGFloat = 10

    var secondaryLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        
        secondaryLabel.translatesAutoresizingMaskIntoConstraints = false
        secondaryLabel.font = secondaryLabel.font
            .withSize(secondaryLabel.font.pointSize - TableViewCell.labelsFontSizeDifference)
        secondaryLabel.textColor = detailTextLabel?.textColor ?? .secondaryLabel
        addSubview(secondaryLabel)
        
        if let textLabel = textLabel {
            secondaryLabel.leadingAnchor.constraint(equalTo: textLabel.trailingAnchor, constant: spacing)
                .isActive = true
        }
        secondaryLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        accessoryType = .none
        textLabel?.text = ""
        secondaryLabel.text = ""
    }
}
