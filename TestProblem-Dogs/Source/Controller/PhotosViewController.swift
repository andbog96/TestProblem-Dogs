//
//  PhotosViewController.swift
//  TestProblem-Dogs
//
//  Created by Andrey Bogdanov on 31.07.2020.
//

import UIKit
import Kingfisher

class PhotosViewController: UIViewController {
    
    private var imageViewsCount = 3
    
    var fullBreed: FullBreed!
    var photosModel: PhotosModel!
    
    private let activityIndicatorView = UIActivityIndicatorView(style: .large)
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let heartButton = HeartButton()
    
    private var currentPage = 0
    private var currentScrollViewOffsetX: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationItem.title = fullBreed.subbreed == nil ? fullBreed.breed : fullBreed.subbreed
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self,
                                                            action: #selector(sharePhoto))
        
        activityIndicatorViewSetup()
        scrollViewSetup()
        stackViewSetup()
        heartButtonSetup()
        
        photosModel.delegate = self
        photosModel.loadPhotos(of: fullBreed)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { contex in
            self.updateScrollOffset()
        }, completion: nil)
    }
    
    private func updateScrollOffset(animated: Bool = true) {
        var offsetX: CGFloat
        if currentPage == 0 {
            offsetX = 0
        } else if currentPage == (photosModel.photos?.count ?? 0) - 1 {
            offsetX = CGFloat(imageViewsCount - 1) * scrollView.frame.width
        } else {
            offsetX = CGFloat(imageViewsCount / 2) * scrollView.frame.width
        }
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: animated)
        
        currentScrollViewOffsetX = scrollView.contentOffset.x
    }
    
    private func activityIndicatorViewSetup() {
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.startAnimating()
        view.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func scrollViewSetup() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.contentSize.height = 0 // turn off vertical scroll
        scrollView.delegate = self
        view.addSubview(scrollView)
        scrollView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        scrollView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor).isActive = true
    }
    
    private func stackViewSetup() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
    
    private func heartButtonSetup() {
        heartButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(heartButton)
        heartButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40)
            .isActive = true
        heartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
            .isActive = true
        
        //heartButton.addTarget(<#T##target: Any?##Any?#>, action: <#T##Selector#>, for: <#T##UIControl.Event#>)
        
        updateHeartButtonImage()
    }
    
    private func updateHeartButtonImage() {
        heartButton.setWhiteImage()
        //
    }
    
    @objc func sharePhoto() {
        func share(_ action: UIAlertAction) {
            if let imageView = stackView.arrangedSubviews[currentPage] as? UIImageView {
                let image = imageView.image!
                let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
                present(activity, animated: true)
            }
        }
        
        let alertController = UIAlertController(title: "Share photo",
                                                message: nil,
                                                preferredStyle: .actionSheet)
        let shareAction = UIAlertAction(title: "Share", style: .default, handler: share)
        alertController.addAction(shareAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
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
    
    private func updatePhotos() {
        guard let photos = photosModel.photos,
              let imageViews = stackView.arrangedSubviews as? [UIImageView] else {
            print("updatePhotos guard fell")
            return
        }
        
        if currentPage == 0 {
            for i in 0..<imageViews.count {
                let imageView = imageViews[i]
                let photoIndex = currentPage + i
                imageView.kf.setImage(with: photos[photoIndex]) { result in
                    if case .failure(_) = result {
                        self.showAlert()
                    }
                }
            }
        } else if currentPage == photos.count - 1 {
            for i in 0..<imageViews.count {
                let imageView = imageViews[i]
                let photoIndex = currentPage + i - (imageViews.count - 1)
                imageView.kf.setImage(with: photos[photoIndex]) { result in
                    if case .failure(_) = result {
                        self.showAlert()
                    }
                }
            }
        } else {
            for i in 0..<imageViews.count {
                let imageView = imageViews[i]
                let photoIndex = currentPage + i - (imageViews.count / 2)
                if 0 <= photoIndex && photoIndex < photos.count {
                    imageView.kf.setImage(with: photos[photoIndex]) { result in
                        if case .failure(_) = result {
                            self.showAlert()
                        }
                    }
                }
            }
            
            updateScrollOffset(animated: false)
        }
    }
}

extension PhotosViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging", scrollView.contentOffset.x)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if currentScrollViewOffsetX > scrollView.contentOffset.x {
            currentPage -= 1
        } else if currentScrollViewOffsetX < scrollView.contentOffset.x {
            currentPage += 1
        } else {
            return
        }
        
        currentScrollViewOffsetX = scrollView.contentOffset.x
        print(currentPage)
        
        updateHeartButtonImage()
        updatePhotos()
    }
}

extension PhotosViewController: PhotosModelDelegate {
    func modelDidLoad() {
        DispatchQueue.main.async {
            updateView()
        }
        
        func updateView() {
            guard let photos = photosModel.photos else {
                showAlert { [self] _ in
                    photosModel.loadPhotos(of: fullBreed)
                }
                
                return
            }
            
            activityIndicatorView.removeFromSuperview()
            
            imageViewsCount = min(imageViewsCount, photos.count)
            for _ in 0..<imageViewsCount {
                let imageView = UIImageView()
                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.contentMode = .scaleAspectFit
                imageView.kf.indicatorType = .activity
                stackView.addArrangedSubview(imageView)
                imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
                imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
                
            }
            
            updatePhotos()
        }
    }
}
