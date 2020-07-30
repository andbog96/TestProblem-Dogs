//
//  DogsPhotos.swift
//  TestProblem-Dogs
//
//  Created by Andrey Bogdanov on 30.07.2020.
//

import Foundation

struct DogsPhotos {
    
    // Because tuples can't be Hashable
    private struct MapKey: Hashable {
        let breedName: String
        let subbreedName: String?
    }
    
    private var map = [MapKey: [String]]()
    
    func getPhotos(_ breedName: String, _ subbreedName: String?) -> [String]? {
        map[MapKey(breedName: breedName, subbreedName: subbreedName)]
    }
    
    mutating func setPhotos(_ breedName: String, _ subbreedName: String?, _ photos: [String]) {
        map[MapKey(breedName: breedName, subbreedName: subbreedName)] = photos
    }
}
