//
//  BreedsModelProtocol.swift
//  TestProblem-Dogs
//
//  Created by Andrey Bogdanov on 30.07.2020.
//

protocol BreedsModelProtocol: class {
    
    var delegate: BreedsModelDelegate! { get set }
    var service: DogsServiceProtocol { get set }
    
    var breed: Breed? { get }
    
    func loadBreeds()
}
