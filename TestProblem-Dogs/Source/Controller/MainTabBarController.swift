//
//  MainTabBarController.swift
//  TestProblem-Dogs
//
//  Created by Andrey Bogdanov on 29.07.2020.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    private let favouritesModel = FavouritesModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let breedsNavigationController = BreedsNavigationController(favouritesModel: favouritesModel)
        let favouritesNavigationController = FavouritesNavigationController(favouritesModel: favouritesModel)
        
        setViewControllers([breedsNavigationController, favouritesNavigationController], animated: true)
    }
}
