//
//  PhotosViewController.swift
//  TestProblem-Dogs
//
//  Created by Andrey Bogdanov on 31.07.2020.
//

import UIKit
import Kingfisher

class PhotosViewController: UIViewController {
    
    private var isRotating: Bool = false
    
    private var fullBreed: FullBreed
    private var photosModel: PhotosModelProtocol!
    private var favouritesModel: FavouritesModelProtocol
    
    private let activityIndicatorView = UIActivityIndicatorView(style: .large)
    private var collectionView: UICollectionView!
    private let heartButton = HeartButton()
    
    private var currentPage = 0
    
    init(fullBreed: FullBreed, photosModel: PhotosModelProtocol, favouritesModel: FavouritesModelProtocol) {
        self.fullBreed = fullBreed
        self.photosModel = photosModel
        self.favouritesModel = favouritesModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateHeartButtonImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationItem.title = fullBreed.subbreed == nil ? fullBreed.breed : fullBreed.subbreed
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self,
                                                            action: #selector(sharePhoto))
        
        activityIndicatorViewSetup()
        collectionViewSetup()
        
        photosModel.delegate = self
        photosModel.loadPhotos(of: fullBreed)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        isRotating = true
        
        coordinator.animate(alongsideTransition: { _ in
            let offsetX = CGFloat(self.currentPage) * self.collectionView.frame.width
            self.collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
            self.collectionView.collectionViewLayout.invalidateLayout()
            
            self.isRotating = false
        }, completion: nil)
    }
    
    private func activityIndicatorViewSetup() {
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.startAnimating()
        view.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func collectionViewSetup() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.alwaysBounceHorizontal = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PhotoCollectionViewCell.self,
                                forCellWithReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier)
    }
    
    private func heartButtonSetup() {
        heartButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(heartButton)
        heartButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40)
            .isActive = true
        heartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
            .isActive = true
        
        heartButton.addTarget(nil, action: #selector(heartButtonTouchUPInside(sender:)), for: .touchUpInside)
        
        updateHeartButtonImage()
    }
    
    private func setupView() {
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        heartButtonSetup()
        
        activityIndicatorView.removeFromSuperview()
    }
    
    private func updateHeartButtonImage() {
        guard let photoURL = photosModel.photos?[currentPage] else {
            return
        }
        
        let breedName = fullBreed.subbreed == nil ? fullBreed.breed : fullBreed.subbreed!
        if favouritesModel.isFavourite(breedName, photoURL) {
            heartButton.setRedImage()
        } else {
            heartButton.setWhiteImage()
        }
    }
    
    @objc func heartButtonTouchUPInside(sender: UIButton) {
        guard let photoURL = photosModel.photos?[currentPage] else {
            return
        }
        
        let breedName = fullBreed.subbreed == nil ? fullBreed.breed : fullBreed.subbreed!
        
        if favouritesModel.changePhotoStatus(breedName, photoURL) {
            heartButton.setRedImage()
        } else {
            heartButton.setWhiteImage()
        }
    }
    
    @objc func sharePhoto() {
        func share(_ action: UIAlertAction) {
            if let photoURL = photosModel.photos?[currentPage] {
                KingfisherManager.shared.retrieveImage(with: photoURL) { result in
                    switch result {
                    case .failure(let error):
                        print(error)
                        self.showAlert()
                    case .success(let value):
                        let activity = UIActivityViewController(activityItems: [value.image],
                                                                applicationActivities: nil)
                        self.present(activity, animated: true)
                    }
                }
            }
        }

        let alertController = UIAlertController(title: "Share photo",
                                                message: nil,
                                                preferredStyle: .actionSheet)
        let shareAction = UIAlertAction(title: "Share", style: .default, handler: share)
        alertController.addAction(shareAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }
    
    private func showAlert(handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: "Some server error",
                                                message: "Try connect later",
                                                preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: handler)
        alertController.addAction(alertAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

extension PhotosViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isRotating {
            return
        }
        
        currentPage = Int(round(collectionView.contentOffset.x / collectionView.frame.width))
        updateHeartButtonImage()
    }
}

extension PhotosViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photosModel.photos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier,
                for: indexPath) as? PhotoCollectionViewCell else {
            return PhotoCollectionViewCell()
        }
        
        if let photoURL = photosModel.photos?[indexPath.row] {
            cell.setImage(photoURL) { result in
                if case .failure(let error) = result {
                    print(error)
                    self.showAlert()
                }
            }
        }
        
        return cell
    }
}

extension PhotosViewController: PhotosModelDelegate {
    func photosModelDidLoad() {
        DispatchQueue.main.async {
            updateView()
        }
        
        func updateView() {
            guard photosModel.photos != nil else {
                showAlert { _ in
                    self.photosModel.loadPhotos(of: self.fullBreed)
                }
                
                return
            }
            
            setupView()
        }
    }
}
