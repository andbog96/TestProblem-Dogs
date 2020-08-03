//
//  BreedsViewController.swift
//  TestProblem-Dogs
//
//  Created by Andrey Bogdanov on 29.07.2020.
//

import UIKit
import Alamofire

class BreedsViewController: UIViewController {
    
    private enum ViewType {
        case breed
        case favourite
    }
    
    private var viewType: ViewType
    
    private var fullBreed: FullBreed? = nil
    private var breedsModel: BreedsModelProtocol!
    private var favouritesModel: FavouritesModelProtocol
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let activityIndicatorView = UIActivityIndicatorView(style: .large)
    private let emptyLabel = UILabel()
    
    init(breedsModel: BreedsModelProtocol, favouritesModel: FavouritesModelProtocol, isFavourites: Bool = false) {
        self.breedsModel = breedsModel
        self.favouritesModel = favouritesModel
        
        viewType = isFavourites ? .favourite : .breed
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.startAnimating()
        view.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        if (breedsModel.breed == nil) {
            breedsModel.loadBreeds(delegate: self)
        } else {
            setupView()
        }
        
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if viewType == .favourite {
            updateView()
        }
    }
    
    private func setupView() {
        activityIndicatorView.removeFromSuperview()
        
        navigationItem.title = breedsModel.breed?.name
        
        if viewType == .favourite {
            emptyLabel.text = "You haven't liked any photos yet."
            emptyLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(emptyLabel)
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        }
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func updateView() {
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

extension BreedsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        breedsModel.breed?.subbreeds?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier,
                                                       for: indexPath) as? TableViewCell else {
            return TableViewCell()
        }
        
        if let breed = breedsModel.breed?.subbreeds?[indexPath.row] {
            cell.firstLabel.text = breed.name
            cell.accessoryType = .disclosureIndicator
            if let subbreeds = breed.subbreeds {
                cell.secondLabel.text = "(\(subbreeds.count) subbreeds)"
            } else if viewType == .favourite {
                cell.secondLabel.text = "(\(favouritesModel.photosCount(breed.name)) photos)"
            }
        }
        
        return cell
    }
}

extension BreedsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let subbreedsModel = breedsModel.getSubbreedsModel(indexPath.row),
              let subbreed = subbreedsModel.breed else {
            return
        }
        
        if subbreedsModel.breed?.subbreeds != nil {
            let subbreedsViewController = BreedsViewController(breedsModel: subbreedsModel,
                                                               favouritesModel: favouritesModel)
            subbreedsViewController.fullBreed = FullBreed(breed: subbreed.name, subbreed: nil)
            
            navigationController?.pushViewController(subbreedsViewController, animated: true)
        } else {
            let fullBreed: FullBreed =
                self.fullBreed == nil || viewType == .favourite
                ? FullBreed(breed: subbreed.name, subbreed: nil)
                : FullBreed(breed: self.fullBreed!.breed, subbreed: subbreed.name)
            
            let photosModel = PhotosModel(service: breedsModel.service)
            let photosViewController = PhotosViewController(fullBreed: fullBreed,
                                                            photosModel: photosModel,
                                                            favouritesModel: favouritesModel)
            
            navigationController?.pushViewController(photosViewController, animated: true)
        }
    }
}

extension BreedsViewController: BreedsModelDelegate {
    func breedsModelDidLoad() {
        DispatchQueue.main.async {
            guard self.breedsModel.breed != nil else {
                let alertController = UIAlertController(title: "Some server error",
                                                        message: "Try connect later",
                                                        preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Ok", style: .default) { _ in
                    self.breedsModel.loadBreeds(delegate: self)
                }
                
                alertController.addAction(alertAction)
                self.present(alertController, animated: true)
                
                return
            }
            
            self.setupView()
        }
    }
}
