//
//  BreedsModelInput.swift
//  TestProblem-Dogs
//
//  Created by Andrey Bogdanov on 30.07.2020.
//

protocol BreedsModelInput: class {
    
    var output: BreedsModelOutput! { get set }
    var service: DogsServiceProtocol!  { get set }
    
    var breeds: [Breed]? { get }
    
    func loadBreeds()
}
