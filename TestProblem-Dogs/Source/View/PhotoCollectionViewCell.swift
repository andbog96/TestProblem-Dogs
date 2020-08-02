//
//  PhotoCollectionViewCell.swift
//  TestProblem-Dogs
//
//  Created by Andrey Bogdanov on 02.08.2020.
//

import UIKit
import Kingfisher

class PhotoCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "PhotoCollectionViewCell"
    
    private let imageView: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.contentMode = .scaleAspectFit
        imageView.kf.indicatorType = .activity
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    func setImage(_ imageURL: URL, handler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) {
        imageView.kf.setImage(with: imageURL, completionHandler: handler)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
