//
//  FavouritesModel.swift
//  TestProblem-Dogs
//
//  Created by Andrey Bogdanov on 02.08.2020.
//

import Foundation

final class FavouritesModel: FavouritesModelProtocol {
    
    weak var delegate: FavouritesModelDelegate!
    var service: DogsServiceProtocol = DogsService.shared
    
    private(set) var favourites: [FullBreed : Set<URL>] = [:]
    
    func markPhoto(_ photoURL: URL) {
        
    }
    
    func unmarkPhoto(_ photoURL: URL) {
        
    }
}
