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
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let activityIndicatorView = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "Breeds"
        
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.startAnimating()
        view.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        breedsModel.delegate = self
        breedsModel.loadBreeds()
        
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
    }
}

extension BreedsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        breedsModel.breeds?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath)
                as? TableViewCell else {
            return TableViewCell()
        }
        
        if let breed = breedsModel.breeds?[indexPath.row] {
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
        guard let breed = breedsModel.breeds?[indexPath.row] else {
            return
        }
        
        if let _ = breed.subbreeds {
            let subbreedsViewController = SubbreedsViewController()            
            subbreedsViewController.breed = breed
            
            navigationController?.pushViewController(subbreedsViewController, animated: true)
        } else {
            let dogsPhotosViewController = DogsPhotosViewController()
            dogsPhotosViewController.dogsPhotosModel = DogsPhotosModel()
            dogsPhotosViewController.fullBreed = FullBreed(breed: breed.name, subbreed: nil)
            
            navigationController?.pushViewController(dogsPhotosViewController, animated: true)
        }
    }
}

extension BreedsViewController: BreedsModelDelegate {
    func modelDidLoad() {
        DispatchQueue.main.async {
            updateView()
        }
        
        func updateView() {
            guard breedsModel.breeds != nil else {
                let alertController = UIAlertController(title: "Some server error",
                                                        message: "Try connect later",
                                                        preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Ok", style: .default) { (_) in
                    self.breedsModel.loadBreeds()
                }
                
                alertController.addAction(alertAction)
                present(alertController, animated: true)
                
                return
            }
            
            activityIndicatorView.removeFromSuperview()
            
            view.addSubview(tableView)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            tableView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        }
    }
}