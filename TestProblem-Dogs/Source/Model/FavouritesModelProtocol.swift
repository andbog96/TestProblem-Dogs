//
//  FavouritesModelProtocol.swift
//  TestProblem-Dogs
//
//  Created by Andrey Bogdanov on 02.08.2020.
//

import Foundation

protocol FavouritesModelProtocol: class {
    
    var breeds: [Breed] { get }
    
    func getPhotos(by name: String) -> [URL]
    
    func photosCount(_ name: String) -> Int
    
    func isFavourite(_ name: String, _ photoURL: URL) -> Bool

    func changePhotoStatus(_ name: String, _ photoURL: URL) -> Bool
}
