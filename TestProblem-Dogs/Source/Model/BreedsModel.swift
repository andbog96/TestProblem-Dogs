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
    var service: DogsServiceProtocol
    
    // nil means error
    private(set) var breed: Breed?
    
    init(service: DogsServiceProtocol) {
        self.service = service
    }
    
    func getSubbreedsModel(_ subbreedIndex: Int) -> BreedsModelProtocol? {
        let subbreedsModel = BreedsModel(service: service)
        
        if let subbreed = breed?.subbreeds?[subbreedIndex] {
            subbreedsModel.breed = subbreed
        } else {
            return nil
        }
        
        return subbreedsModel
    }
    
    func loadBreeds(delegate: BreedsModelDelegate) {
        self.delegate = delegate
        
        service.getBreeds { breeds in
            self.breed = breeds.map(Breed.init)
            
            delegate.breedsModelDidLoad()
        }
    }
}
