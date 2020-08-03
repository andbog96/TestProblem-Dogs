//
//  FavouritesNavigationController.swift
//  TestProblem-Dogs
//
//  Created by Andrey Bogdanov on 29.07.2020.
//

import UIKit

class FavouritesNavigationController: UINavigationController {

    private var breedsViewController: BreedsViewController
    
    init(favouritesModel: FavouritesModelProtocol) {
        let breedsModel = BreedsModel(service: FavouritesService(favouritesModel: favouritesModel))
        breedsViewController = BreedsViewController(breedsModel: breedsModel,
                                                    favouritesModel: favouritesModel,
                                                    isFavourites: true)
        
        super.init(rootViewController: breedsViewController)
        
        let image = UIImage(systemName: "heart")
        let selectedImage = UIImage(systemName: "heart.fill")
        tabBarItem = UITabBarItem(title: "Favourites", image: image,
                                  selectedImage: selectedImage)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
