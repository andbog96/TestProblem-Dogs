//
//  DogsServiceProtocol.swift
//  TestProblem-Dogs
//
//  Created by Andrey Bogdanov on 30.07.2020.
//

import Foundation

protocol DogsServiceProtocol {
    
    func getBreeds(_ callback: @escaping ([Breed]?) -> Void)
    func getDogsPhotos(of breed: FullBreed, _ callback: @escaping ([URL]?) -> Void)
}
