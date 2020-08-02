//
//  PhotosModelProtocol.swift
//  TestProblem-Dogs
//
//  Created by Andrey Bogdanov on 30.07.2020.
//

import Foundation

protocol PhotosModelProtocol: class {
    
    var delegate: PhotosModelDelegate! { get set }
    var service: DogsServiceProtocol { get set }
    
    var photos: [URL]? { get }
    
    func loadPhotos(of breed: FullBreed)
}
