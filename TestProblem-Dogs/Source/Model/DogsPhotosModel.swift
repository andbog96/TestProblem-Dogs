//
//  DogsPhotosModel.swift
//  TestProblem-Dogs
//
//  Created by Andrey Bogdanov on 30.07.2020.
//

import Foundation


class DogsPhotosModel: DogsPhotosModelProtocol {
    
    var delegate: DogsPhotosModelDelegate!
    var service: DogsServiceProtocol = DogsService.shared
    
    // nil means error
    private(set) var dogsPhotos: [URL]?
    
    func loadDogsPhotos(of breed: FullBreed) {
        service.getDogsPhotos(of: breed) { photos in
            self.dogsPhotos = photos
            self.delegate.modelDidLoad()
        }
    }
}
