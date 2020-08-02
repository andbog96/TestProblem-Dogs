//
//  BreedsModel.swift
//  TestProblem-Dogs
//
//  Created by Andrey Bogdanov on 29.07.2020.
//

import Foundation
import Alamofire

final class BreedsModel: BreedsModelProtocol {
    
    weak var delegate: BreedsModelDelegate!
    var service: DogsServiceProtocol = DogsService.shared
    
    // nil means error
    private(set) var breed: Breed?
    
    func loadBreeds() {
        service.getBreeds { breeds in
            self.breed = breeds.map(Breed.init)
            
            self.delegate.breedsModelDidLoad()
        }
    }
}
