//
//  FavouritesNavigationController.swift
//  TestProblem-Dogs
//
//  Created by Andrey Bogdanov on 29.07.2020.
//

import UIKit

class FavouritesNavigationController: UINavigationController {

    init() {
        super.init(rootViewController: UIViewController())
        
        let image = UIImage(systemName: "heart")
        let selectedImage = UIImage(systemName: "heart.fill")
        tabBarItem = UITabBarItem(title: "Favourites", image: image, selectedImage: selectedImage)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
