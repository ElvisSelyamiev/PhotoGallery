//
//  FavoritePhotoCell.swift
//  BroadAppsTestTask
//
//  Created by Elvis on 14.10.2022.
//

import UIKit
import SDWebImage

protocol DeleteButtonDelegate: AnyObject {
    func deleteData(model: FavoriteModel)
}

final class FavoritePhotoCell: UITableViewCell {
    
    static let reuseIdentifier = "FavoritePhotoCell"
    
    var favoriteModel: FavoriteModel!
    weak var delegate: DeleteButtonDelegate?
    
    private let authorName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let photoImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "trash.circle")
        button.setImage(image, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(deleteData), for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(authorName: String, photoURL: String) {
        self.authorName.text = authorName
        
        let imgURL = photoURL
        guard let url = URL(string: imgURL) else { return }
        photoImageView.sd_setImage(with: url, completed: nil)
    }
    
    @objc func deleteData() {
        delegate?.deleteData(model: favoriteModel)
    }
    
    private func setupViews() {
        contentView.addSubview(photoImageView)
        contentView.addSubview(authorName)
        contentView.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            photoImageView.heightAnchor.constraint(equalToConstant: 80),
            photoImageView.widthAnchor.constraint(equalToConstant: 80),
            
            authorName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            authorName.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 20),
            
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            deleteButton.leadingAnchor.constraint(equalTo: authorName.trailingAnchor, constant: 18),
            deleteButton.heightAnchor.constraint(equalToConstant: 30),
            deleteButton.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
}
