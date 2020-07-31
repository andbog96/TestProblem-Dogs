//
//  DogsPhotosViewController.swift
//  TestProblem-Dogs
//
//  Created by Andrey Bogdanov on 31.07.2020.
//

import UIKit

class DogsPhotosViewController: UIViewController {

    var fullBreed: FullBreed!
    var dogsPhotosModel: DogsPhotosModel!
    
    private let activityIndicatorView = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = fullBreed.subbreed == nil ? fullBreed.breed : fullBreed.subbreed

        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.startAnimating()
        view.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        dogsPhotosModel.delegate = self
        dogsPhotosModel.loadDogsPhotos(of: fullBreed)
        
    }

}

extension DogsPhotosViewController: DogsPhotosModelDelegate {
    func modelDidLoad() {
        DispatchQueue.main.async {
            updateView()
        }
        
        func updateView() {
            guard dogsPhotosModel.dogsPhotos != nil else {
                let alertController = UIAlertController(title: "Some server error",
                                                        message: "Try connect later",
                                                        preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Ok", style: .default) { (_) in
                    self.dogsPhotosModel.loadDogsPhotos(of: self.fullBreed)
                }

                alertController.addAction(alertAction)
                present(alertController, animated: true)

                return
            }

            activityIndicatorView.removeFromSuperview()

        }
    }
}
