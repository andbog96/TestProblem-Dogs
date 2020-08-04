//
//  FavouritesViewController.swift
//  TestProblem-Dogs
//
//  Created by Andrey Bogdanov on 04.08.2020.
//

import Foundation

import UIKit

class FavouritesViewController: BreedsViewController {
    
    private var fullBreed: FullBreed? = nil
    private var breedsModel: BreedsModelProtocol!
    private var favouritesModel: FavouritesModelProtocol
    
    private let emptyLabel = UILabel()
    
    override init(breedsModel: BreedsModelProtocol, favouritesModel: FavouritesModelProtocol) {
        self.breedsModel = breedsModel
        self.favouritesModel = favouritesModel
        
        super.init(breedsModel: breedsModel, favouritesModel: favouritesModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateView()
    }
    
    override func setupView() {
        emptyLabel.text = "You haven't liked any photos yet."
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyLabel)
        emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        super.setupView()
    }
    
    private func updateView() {
        breedsModel.loadBreeds(delegate: self)
        if let count = breedsModel.breed?.subbreeds?.count,
            count != 0 {
            emptyLabel.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        } else {
            emptyLabel.isHidden = false
            tableView.isHidden = true
        }
    }
}

extension FavouritesViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier,
                                                       for: indexPath) as? TableViewCell
            else {
                return TableViewCell()
        }
        
        if let breed = breedsModel.breed?.subbreeds?[indexPath.row] {
            cell.firstLabel.text = breed.name
            cell.accessoryType = .disclosureIndicator
            
            let count = favouritesModel.photosCount(breed.name)
            let ending = count == 1 ? "" : "s"
            cell.secondLabel.text = "(\(count) photo\(ending))"
        }
        
        return cell
    }
}

extension FavouritesViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let subbreedsModel = breedsModel.getSubbreedsModel(indexPath.row),
            let subbreed = subbreedsModel.breed else {
                return
        }
        
        let fullBreed: FullBreed = FullBreed(breed: subbreed.name, subbreed: nil)
        
        let photosModel = PhotosModel(service: breedsModel.service)
        let photosViewController = PhotosViewController(fullBreed: fullBreed,
                                                        photosModel: photosModel,
                                                        favouritesModel: favouritesModel)
        
        navigationController?.pushViewController(photosViewController, animated: true)
    }
}
