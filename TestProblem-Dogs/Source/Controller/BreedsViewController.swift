//
//  BreedsViewController.swift
//  TestProblem-Dogs
//
//  Created by Andrey Bogdanov on 29.07.2020.
//

import UIKit
import Alamofire

class BreedsViewController: UIViewController {
    
    var breedsModel: BreedsModelProtocol!
    var breed: Breed? = nil
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let activityIndicatorView = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationItem.title = "Breeds"
        
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.startAnimating()
        view.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        if (breed == nil) {
            breedsModel.delegate = self
            breedsModel.loadBreeds()
        } else {
            setupView()
        }
        
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupView() {
        activityIndicatorView.removeFromSuperview()
        
        navigationItem.title = breed?.name
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
}

extension BreedsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        breed?.subbreeds?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier,
                                                       for: indexPath) as? TableViewCell else {
            return TableViewCell()
        }
        
        if let breed = breed?.subbreeds?[indexPath.row] {
            cell.firstLabel.text = breed.name
            cell.accessoryType = .disclosureIndicator
            if let subbreeds = breed.subbreeds {
                cell.secondLabel.text = "(\(subbreeds.count) subbreeds)"
            }
        }
        
        return cell
    }
}

extension BreedsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let breed = breed,
            let subbreed = breed.subbreeds?[indexPath.row] else {
            return
        }
        
        if subbreed.subbreeds != nil {
            let subbreedsViewController = BreedsViewController()
            subbreedsViewController.breed = subbreed
            
            navigationController?.pushViewController(subbreedsViewController, animated: true)
        } else {
            let photosViewController = PhotosViewController()
            photosViewController.photosModel = PhotosModel()
            photosViewController.fullBreed = FullBreed(breed: breed.name, subbreed: subbreed.name)
            
            navigationController?.pushViewController(photosViewController, animated: true)
        }
    }
}

extension BreedsViewController: BreedsModelDelegate {
    func breedsModelDidLoad() {
        DispatchQueue.main.async {
            guard let breed = self.breedsModel.breed else {
                let alertController = UIAlertController(title: "Some server error",
                                                        message: "Try connect later",
                                                        preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Ok", style: .default) { _ in
                    self.breedsModel.loadBreeds()
                }
                
                alertController.addAction(alertAction)
                self.present(alertController, animated: true)
                
                return
            }
            
            self.breed = breed
            self.setupView()
        }
    }
}
