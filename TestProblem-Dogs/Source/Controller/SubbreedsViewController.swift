//
//  SubbreedsViewController.swift
//  TestProblem-Dogs
//
//  Created by Andrey Bogdanov on 30.07.2020.
//

import UIKit

class SubbreedsViewController: UIViewController {
    
    var breed: Breed!
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = breed.name
        
        view.addSubview(tableView)
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
}

extension SubbreedsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        breed.subbreeds?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath)
                as? TableViewCell else {
            return TableViewCell()
        }
        
        if let subbreed = breed.subbreeds?[indexPath.row] {
            cell.firstLabel.text = subbreed.name
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
}

extension SubbreedsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let subbreed = breed.subbreeds?[indexPath.row] else {
            return
        }
        
        let dogsPhotosViewController = DogsPhotosViewController()
        dogsPhotosViewController.dogsPhotosModel = DogsPhotosModel()
        dogsPhotosViewController.fullBreed = FullBreed(breed: breed.name, subbreed: subbreed.name)
        
        navigationController?.pushViewController(dogsPhotosViewController, animated: true)
    }
}
