//
//  Breed.swift
//  TestProblem-Dogs
//
//  Created by Andrey Bogdanov on 30.07.2020.
//

import Foundation

struct Breed {
    
    let name: String
    var subbreeds: [Breed]? = nil
    
    fileprivate static let rootName = "Breeds"
    fileprivate static let favouritesName = "Favourites"
    
    init(name: String) {
        self.name = name.capitalized
    }
    
    init(subbreeds: [Breed]?) {
        self.init(name: Breed.rootName, subbreeds: subbreeds)
    }
    
    init(name: String, subbreeds: [Breed]?) {
        self.name = name.capitalized
        
        if let sub = subbreeds, !sub.isEmpty {
            self.subbreeds = sub.sorted{$0.name < $1.name}
        }
    }
    
    init(name: String, subbreeds: [String]) {
        self.init(name: name, subbreeds: subbreeds.map(\.capitalized).map(Breed.init))
    }
}

struct FullBreed: Hashable {
    let breed: String
    let subbreed: String?
    
    var isRoot: Bool {
        breed == Breed.rootName
    }
}
