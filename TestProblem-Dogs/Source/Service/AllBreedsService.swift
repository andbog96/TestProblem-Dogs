//
//  DogsService.swift
//  TestProblem-Dogs
//
//  Created by Andrey Bogdanov on 30.07.2020.
//

import Foundation
import Alamofire

struct AllBreedsService: DogsServiceProtocol {
    
    private let allBreedsURLString = "https://dog.ceo/api/breeds/list/all"
    private func getPhotosULRStrings(for breed: FullBreed) -> String {
        "https://dog.ceo/api/breed/" + breed.breed.lowercased()
            + (breed.subbreed == nil ? "" : ("/" + breed.subbreed!.lowercased()))
            + "/images"
    }
    
    func getBreeds(_ callback: @escaping ([Breed]?) -> Void) {
        AF.request(allBreedsURLString).validate().responseJSON { response in
            switch response.result {
            case let .failure(error):
                print(error)
                callback(nil)
            case .success:
                if let json = try? JSONDecoder().decode(BreadsResponse.self, from: response.data!) {
                    callback(json.message.map(Breed.init))
                } else {
                    callback(nil)
                }
            }
        }
    }
    
    func getPhotos(of breed: FullBreed, _ callback: @escaping ([URL]?) -> Void) {
        let url = breed.isRoot
            ? getPhotosULRStrings(for: FullBreed(breed: breed.subbreed!, subbreed: nil))
            : getPhotosULRStrings(for: breed)
        
        AF.request(url).validate().responseJSON { response in
            switch response.result {
            case let .failure(error):
                print(error)
                callback(nil)
            case .success:
                if let json = try? JSONDecoder().decode(PhotosResponse.self, from: response.data!) {
                    callback(json.message.compactMap(URL.init(string:)))
                } else {
                    callback(nil)
                }
            }
        }
    }
    
    private struct BreadsResponse: Codable {
        let message: [String: [String]]
    }
    
    private struct PhotosResponse: Codable {
        let message: [String]
    }
}
