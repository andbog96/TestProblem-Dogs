//
//  FavouritesModel.swift
//  TestProblem-Dogs
//
//  Created by Andrey Bogdanov on 02.08.2020.
//

import Foundation
import RealmSwift

class Favourite: Object {
    @objc dynamic var name = ""
    @objc dynamic var photo = ""
}

final class FavouritesModel: FavouritesModelProtocol {
    
    var breeds: [Breed] {
        print("breeds")
        return Set(realm.objects(Favourite.self).map(\.name)).sorted().map(Breed.init)
    }
    
    private var realm: Realm
    
    init() {
        guard let realm = try? Realm() else {
            fatalError()
        }
        
        self.realm = realm
    }
    
    func getPhotos(by name: String) -> [URL] {
        print("getPhotos")
        
        return realm.objects(Favourite.self).filter({$0.name == name}).map(\.photo).compactMap(URL.init(string:))
    }
    
    func photosCount(_ name: String) -> Int {
        print("photosCount")
        
        return realm.objects(Favourite.self).filter({$0.name == name}).count
    }
    
    func isFavourite(_ name: String, _ photoURL: URL) -> Bool {
        print("isFavourite")
        
        let photo = photoURL.absoluteString
        
        return !realm.objects(Favourite.self).filter({$0.photo == photo}).isEmpty
    }
    
    func changePhotoStatus(_ name: String, _ photoURL: URL) -> Bool {
        print("changePhotoStatus")
        
        let photoURLString = photoURL.absoluteString
        let photo = realm.objects(Favourite.self).filter({$0.photo == photoURLString})
        if photo.isEmpty {
            try? realm.write {
                let favourite = Favourite()
                favourite.name = name
                favourite.photo = photoURLString
                realm.add(favourite)
            }
            
            return true
        } else {
            try? realm.write {
                realm.delete(photo)
            }
            
            return false
        }
    }
}
