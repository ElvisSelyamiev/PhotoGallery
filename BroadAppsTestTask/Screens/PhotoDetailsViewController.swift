//
//  PhotoDetailsViewController.swift
//  BroadAppsTestTask
//
//  Created by Elvis on 13.10.2022.
//

import UIKit
import SDWebImage
import RealmSwift

final class PhotoDetailsViewController: UIViewController {
    
    var photoModel: UnsplashResult!
    var favoriteModel: FavoriteModel?
    var isFavorite: Bool = false
    
    private let realm = try! Realm()
    private let model = FavoriteModel()
    private let defaults = UserDefaults.standard
    
    private let photoImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .clear
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let numberOfLikes = UILabel()
    private let authorLabel = UILabel()
    private let dateCreationLabel = UILabel()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(closeDetailsScreen), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var addToFavoritesButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "heart.circle")
        button.setImage(image, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.tintColor = .systemPink
        button.addTarget(self, action: #selector(addToFavoritesAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupButtons()
        setupViews()
    }
    
// MARK: - Actions
    @objc private func closeDetailsScreen() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func addToFavoritesAction() {
        saveData()
    }
    
//    MARK: - Configurate
    func configure(name: String?, dateCreation: String, likes: Int, photoURL: String?) {
        numberOfLikes.font = .boldSystemFont(ofSize: 16)
        authorLabel.font = .boldSystemFont(ofSize: 16)
        dateCreationLabel.font = .boldSystemFont(ofSize: 16)
        
        guard let name = name else { return }
        numberOfLikes.text = "Likes: \(likes)"
        authorLabel.text = "Author: \(name)"
        dateCreationLabel.text = "Created in: \(dateCreation)"
        
        let photo = photoURL
        guard let imageUrl = photo, let url = URL(string: imageUrl) else { return }
        photoImage.sd_setImage(with: url, completed: nil)
    }
    
//    MARK: - Save Data
    private func saveData() {
        let photoForCell = photoModel.urls["thumb"]
        let photoForScreen = photoModel.urls["small"]
        guard let cellImage = photoForCell, let screenImg = photoForScreen else { return }
        guard let name = photoModel.user.name else { return }
        model.likes = photoModel.likes
        model.authorName = name
        model.created_at = photoModel.created_at
        model.photoUrlForCell = cellImage
        model.photoUrlForScreen = screenImg
        
        try! realm.write {
            realm.add(model)
        }
    }
    
//    MARK: - Setup UI
    private func setupButtons() {
        view.addSubview(closeButton)
        view.addSubview(addToFavoritesButton)
                
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            addToFavoritesButton.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 310),
            addToFavoritesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addToFavoritesButton.heightAnchor.constraint(equalToConstant: 40),
            addToFavoritesButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupViews() {
        view.addSubview(photoImage)
        view.addSubview(numberOfLikes)
        view.addSubview(authorLabel)
        view.addSubview(dateCreationLabel)
        
        numberOfLikes.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        dateCreationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            photoImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 75),
            photoImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            photoImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            photoImage.heightAnchor.constraint(equalToConstant: 300),
            
            numberOfLikes.topAnchor.constraint(equalTo: photoImage.bottomAnchor, constant: 20),
            numberOfLikes.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            authorLabel.topAnchor.constraint(equalTo: numberOfLikes.bottomAnchor, constant: 10),
            authorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            dateCreationLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 10),
            dateCreationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
    }
}
