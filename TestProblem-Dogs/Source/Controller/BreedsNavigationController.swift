//
//  BreedsNavigationController.swift
//  TestProblem-Dogs
//
//  Created by Andrey Bogdanov on 29.07.2020.
//

import UIKit

class BreedsNavigationController: UINavigationController {
    
    init(favouritesModel: FavouritesModelProtocol) {
        let breedsModel = BreedsModel(service: AllBreedsService())
        let breedsViewController = BreedsViewController(breedsModel: breedsModel,
                                                        favouritesModel: favouritesModel)
        
        super.init(rootViewController: breedsViewController)
        
        let image = UIImage(systemName: "list.bullet.rectangle")
        tabBarItem = UITabBarItem(title: "List", image: image, tag: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
