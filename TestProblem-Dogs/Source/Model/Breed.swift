//
//  Breed.swift
//  TestProblem-Dogs
//
//  Created by Andrey Bogdanov on 30.07.2020.
//

import Foundation

struct Breed {
    
    let name: String
    let subbreeds: [Breed]?
    
    init(name: String) {
        self.init(name: name, subbreeds: [])
    }
    
    init(name: String, subbreeds: [String]) {
        self.name = name.capitalized
        
        self.subbreeds = subbreeds.isEmpty
            ? nil
            : subbreeds.map(\.capitalized).map(Breed.init)
    }
}

struct FullBreed {
    let breed: String
    let subbreed: String?
}
