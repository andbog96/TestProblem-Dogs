//
//  DogsService.swift
//  TestProblem-Dogs
//
//  Created by Andrey Bogdanov on 30.07.2020.
//

import Foundation
import Alamofire

struct DogsService: DogsServiceProtocol {
    
    static let shared: Self = Self()
    
    private let allBreedsURLString = "https://dog.ceo/api/breeds/list/all"
    private func getPictureULRStrings(for breed: String, _ subbreed: String) -> String {
        "https://dog.ceo/api/" + breed + "/" + subbreed + "/images"
    }
    
    func getBreeds(_ callback: @escaping ([Breed]?) -> Void) {
        AF.request(allBreedsURLString).validate().responseJSON { response in
            switch response.result {
            case let .failure(error):
                print(error)
                callback(nil)
            case .success:
                if let json = try? JSONDecoder().decode(BreadsResponse.self, from: response.data!) {
                    callback(responseMessageToBreeds(json.message))
                } else {
                    callback(nil)
                }
            }
        }
    }
    
    private func responseMessageToBreeds(_ message: [String: [String]]) -> [Breed] {
        message.map { breedName, subbreeds in
            Breed(name: breedName, subbreeds: subbreeds)
        }
    }
    
    func getPictures(for breed: String, _ subbreed: String) -> [URL] {
        return []
    }
    
    struct BreadsResponse: Codable {
        let message: [String: [String]]
    }
}
