//
//  DogsPhotosModelInput.swift
//  TestProblem-Dogs
//
//  Created by Andrey Bogdanov on 30.07.2020.
//

protocol DogsPhotosModelInput: class {
    
    var output: DogsPhotosModelOutput! { get set }
    var service: DogsServiceProtocol!  { get set }
    
    var dogsPhotos: DogsPhotos { get }
    
    func loadPhotos(breedName: String, subbreedName: String?)
}
