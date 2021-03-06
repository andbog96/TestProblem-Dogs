//
//  PhotosModel.swift
//  TestProblem-Dogs
//
//  Created by Andrey Bogdanov on 30.07.2020.
//

import Foundation


final class PhotosModel: PhotosModelProtocol {
    
    var delegate: PhotosModelDelegate!
    var service: DogsServiceProtocol
    
    // nil means error
    private(set) var photos: [URL]?
    
    init(service: DogsServiceProtocol) {
        self.service = service
    }
    
    func loadPhotos(of breed: FullBreed) {
        service.getPhotos(of: breed) { photos in
            self.photos = photos
            
            self.delegate.photosModelDidLoad()
        }
    }
}
