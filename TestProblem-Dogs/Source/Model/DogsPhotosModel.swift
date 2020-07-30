//
//  DogsPhotosModel.swift
//  TestProblem-Dogs
//
//  Created by Andrey Bogdanov on 30.07.2020.
//

import Foundation

class DogsPhotosModel: DogsPhotosModelInput {
    
    
    var output: DogsPhotosModelOutput!
    var service: DogsServiceProtocol!
    
    private(set) var dogsPhotos = DogsPhotos()
    
    func loadPhotos(breedName: String, subbreedName: String?) {
        
    }
}
