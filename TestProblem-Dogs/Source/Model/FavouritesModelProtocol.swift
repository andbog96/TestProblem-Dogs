//
//  FavouritesModelProtocol.swift
//  TestProblem-Dogs
//
//  Created by Andrey Bogdanov on 02.08.2020.
//

import Foundation

protocol FavouritesModelProtocol {
    
    var delegate: FavouritesModelDelegate! { get set }
    var service: DogsServiceProtocol { get set }
    
    var favourites: [FullBreed: Set<URL>] { get }

    func markPhoto(_ photoURL: URL)
    func unmarkPhoto(_ photoURL: URL)
}
