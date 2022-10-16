//
//  PhotoCollectionViewCell.swift
//  BroadAppsTestTask
//
//  Created by Elvis on 13.10.2022.
//

import UIKit
import SDWebImage

final class PhotoCollectionViewCell: UICollectionViewCell {
    
    var unsplashResult: UnsplashResult! {
        didSet {
            let photo = unsplashResult.urls["regular"]
            guard let imgURL = photo, let url = URL(string: imgURL) else { return }
            photoImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    static let reuseIdentifiere = "PhotoCollectionViewCell"
    
    private let photoImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .lightGray
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupPhoto()
    }
    
    private func setupPhoto() {
        addSubview(photoImageView)
        
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: self.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
