//
//  DogsPhotosModelProtocol.swift
//  TestProblem-Dogs
//
//  Created by Andrey Bogdanov on 30.07.2020.
//

import Foundation

protocol DogsPhotosModelProtocol: class {
    
    var delegate: DogsPhotosModelDelegate! { get set }
    var service: DogsServiceProtocol { get set }
    
    var dogsPhotos: [URL]? { get }
    
    func loadDogsPhotos(of breed: FullBreed)
}
