//
//  DogsServiceProtocol.swift
//  TestProblem-Dogs
//
//  Created by Andrey Bogdanov on 30.07.2020.
//

import Foundation

protocol DogsServiceProtocol {
    
    func getBreeds(_ callback: @escaping ([Breed]?) -> Void)
    func getPictures(for breed: String, _ subbreed: String) -> [URL]
}
