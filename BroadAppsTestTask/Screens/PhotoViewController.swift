//
//  PhotoViewController.swift
//  BroadAppsTestTask
//
//  Created by Elvis on 12.10.2022.
//

import UIKit
import RealmSwift

final class PhotoViewController: UIViewController {
    
    var dataFetch = DataFetch()
    
    private var timer: Timer?
    private var photos = [UnsplashResult]()
    private var collectionView: UICollectionView?
    
    private let reuseIdentifiere = PhotoCollectionViewCell.reuseIdentifiere
    private let realm = try! Realm()
    private let itemInOneLine: CGFloat = 2
    private let insets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupCollectionView()
        setupNavBar()
        setupSearchBar()
    }
    
//    MARK: - Action
    @objc private func addButtonAction() {
        print(#function)
    }
    
    @objc private func saveButtonAction(sender: UIBarButtonItem) {
        print(#function)
    }
    
//    MARK: - Setup UI
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        guard let collectionView = collectionView else { return }
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifiere)
        collectionView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNavBar() {
        let titleLabel = UILabel()
        titleLabel.text = "Photo"
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .darkText
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController()
        navigationItem.searchController = searchController
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
    }
}


// MARK: - Extension for CollectionViewDataSource, Delegate
extension PhotoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifiere, for: indexPath) as! PhotoCollectionViewCell
        let photo = photos[indexPath.item]
        cell.unsplashResult = photo
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let modalPhotoDetailVC = PhotoDetailsViewController()
        let photo = photos[indexPath.item]
        modalPhotoDetailVC.photoModel = photo
        modalPhotoDetailVC.configure(name: photo.user.name, dateCreation: photo.created_at, likes: photo.likes, photoURL: photo.urls["small"])
        modalPhotoDetailVC.modalPresentationStyle = .fullScreen
        present(modalPhotoDetailVC, animated: true, completion: nil)
    }
}

// MARK: - Extension for CollectionViewDelegateFlowLayout
extension PhotoViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let photo = photos[indexPath.item]
        let padding = insets.left * (itemInOneLine + 1)
        let calculatedWidth = view.frame.width - padding
        let finalWidth = calculatedWidth / itemInOneLine
        let height = CGFloat(photo.height) * finalWidth / CGFloat(photo.width)
        return CGSize(width: finalWidth, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return insets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return insets.left
    }
}

// MARK: - Extension for UISearchBar Delegate
extension PhotoViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false, block: { _ in
            self.dataFetch.fetchImage(searchTerm: searchText) { [weak self] searchRes in
                guard let self = self else { return }
                guard let fetched = searchRes else { return }
                self.photos = fetched.results
                self.collectionView?.reloadData()
            }
        })
    }
}
