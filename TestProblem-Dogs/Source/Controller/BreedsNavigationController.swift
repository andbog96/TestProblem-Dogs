//
//  BreedsNavigationController.swift
//  TestProblem-Dogs
//
//  Created by Andrey Bogdanov on 29.07.2020.
//

import UIKit

class BreedsNavigationController: UINavigationController {
    
    init() {
        let breedsViewController = BreedsViewController()
        let model = BreedsModel()
        model.service = DogsService.shared
        breedsViewController.model = model
        
        super.init(rootViewController: breedsViewController)
        
        let image = UIImage(systemName: "list.bullet")
        tabBarItem = UITabBarItem(title: "List", image: image, tag: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
