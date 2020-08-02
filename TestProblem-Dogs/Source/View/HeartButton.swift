//
//  HeartButton.swift
//  TestProblem-Dogs
//
//  Created by Andrey Bogdanov on 01.08.2020.
//

import UIKit

class HeartButton: UIButton {
    
    private let backgroundImage = UIImage(systemName: "heart.fill")?
        .withTintColor(.red, renderingMode: .alwaysOriginal)
    private let whiteImage = UIImage(systemName: "heart.fill")?
        .withTintColor(.white, renderingMode: .alwaysOriginal)
    private let redImage = UIImage(systemName: "heart.fill")?
        .withTintColor(.red, renderingMode: .alwaysOriginal)
    
    private let foregroundImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setImage(backgroundImage, for: .normal)
        setPreferredSymbolConfiguration(
            UIImage.SymbolConfiguration(pointSize: 35, weight: .regular, scale: .large), forImageIn: .normal)
        
        foregroundImageView.image = whiteImage
        foregroundImageView.preferredSymbolConfiguration =
            UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .large)
        addSubview(foregroundImageView)
        
        foregroundImageView.translatesAutoresizingMaskIntoConstraints = false
        if let imageView = imageView {
            foregroundImageView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
            foregroundImageView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        }
        
        setWhiteImage()
    }
    
    func setWhiteImage() {
        foregroundImageView.image = whiteImage
    }
    
    func setRedImage() {
        foregroundImageView.image = redImage
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
