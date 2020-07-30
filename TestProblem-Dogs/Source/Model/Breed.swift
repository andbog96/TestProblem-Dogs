//
//  Breed.swift
//  TestProblem-Dogs
//
//  Created by Andrey Bogdanov on 30.07.2020.
//

import Foundation

struct Breed {
    
    let name: String
    let subbreeds: [Subbreed]?
    
    struct Subbreed {
        let name: String
    }
    
    init(name: String, subbreeds: [String]) {
        self.name = name.capitalized
        self.subbreeds = subbreeds.isEmpty
            ? nil
            : subbreeds.map(\.capitalized).map(Subbreed.init)
        
    }
}
