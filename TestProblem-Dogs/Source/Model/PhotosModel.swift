//
//  PhotosModel.swift
//  TestProblem-Dogs
//
//  Created by Andrey Bogdanov on 30.07.2020.
//

import Foundation


final class PhotosModel: PhotosModelProtocol {
    
    var delegate: PhotosModelDelegate!
    var service: DogsServiceProtocol = DogsService.shared
    
    // nil means error
    private(set) var photos: [URL]?
    
    func loadPhotos(of breed: FullBreed) {
        service.getPhotos(of: breed) { [self] photos in
            self.photos = photos
            
            delegate.photosModelDidLoad()
        }
    }
}
