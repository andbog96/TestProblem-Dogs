//
//  BreedsModel.swift
//  TestProblem-Dogs
//
//  Created by Andrey Bogdanov on 29.07.2020.
//

import Foundation
import Alamofire

class BreedsModel: BreedsModelInput {
    
    weak var output: BreedsModelOutput!
    var service: DogsServiceProtocol!
    
    // nil means error
    private(set) var breeds: [Breed]?
    
    //var dogsPhotos: DogsPhotos
    
    func loadBreeds() {
        service.getBreeds { breeds in
            self.breeds = breeds?.sorted{$0.name < $1.name}
            self.output.modelDidLoad()
        }
    }
}
