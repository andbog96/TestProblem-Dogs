//
//  MainTabBarController.swift
//  TestProblem-Dogs
//
//  Created by Andrey Bogdanov on 29.07.2020.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let breedsNavigationController = BreedsNavigationController()
        let favouritesNavigationController = FavouritesNavigationController()
        
        setViewControllers([breedsNavigationController, favouritesNavigationController], animated: true)
    }
}
