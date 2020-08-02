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
    
    fileprivate static let rootName = "Breeds"
    
    init(name: String) {
        self.name = name.capitalized
        subbreeds = nil
    }
    
    init(subbreeds: [Breed]?) {
        self.init(name: Breed.rootName, subbreeds: subbreeds)
    }
    
    init(name: String, subbreeds: [Breed]?) {
        self.name = name.capitalized
        
        if let sub = subbreeds, !sub.isEmpty {
            self.subbreeds = sub.sorted{$0.name < $1.name}
        } else {
            self.subbreeds = nil
        }
    }
    
    init(name: String, subbreeds: [String]) {
        self.init(name: name, subbreeds: subbreeds.map(\.capitalized).map(Breed.init))
    }
}

struct FullBreed {
    let breed: String
    let subbreed: String?
    
    var isRoot: Bool {
        breed == Breed.rootName
    }
}
