//
//  FavoritePhotosViewController.swift
//  BroadAppsTestTask
//
//  Created by Elvis on 12.10.2022.
//

import UIKit
import RealmSwift

final class FavoritePhotoViewController: UITableViewController {
    
    private let reuseIdentifier = FavoritePhotoCell.reuseIdentifier
    private let realm = try! Realm()
    
    private var model = [FavoriteModel]()
    
    private lazy var refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshTableView))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .white
        tableView.register(FavoritePhotoCell.self, forCellReuseIdentifier: reuseIdentifier)
        fetchRealmData()
        setupNavBar()
    }
    
    @objc private func refreshTableView() {
        self.model.removeAll()
        fetchRealmData()
    }
    
    private func fetchRealmData() {
        let model = realm.objects(FavoriteModel.self)
        for data in model {
            self.model.append(data)
        }
        tableView.reloadData()
    }
    
    private func setupNavBar() {
        let titleLabel = UILabel()
        titleLabel.text = "Favorite"
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .darkText
        navigationItem.rightBarButtonItem = refreshButton
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
    }
}


extension FavoritePhotoViewController: DeleteButtonDelegate {
    
    func deleteData(model: FavoriteModel) {
        try! realm.write {
            realm.delete(model)
        }
        self.model.removeAll()
        fetchRealmData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FavoritePhotoCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! FavoritePhotoCell
        let data = model[indexPath.row]
        cell.delegate = self
        cell.favoriteModel = data
        cell.configure(authorName: data.authorName, photoURL: data.photoUrlForCell)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let modalPhotoDetailVC = PhotoDetailsViewController()
        let data = model[indexPath.row]
        modalPhotoDetailVC.favoriteModel = data
        modalPhotoDetailVC.configure(name: data.authorName, dateCreation: data.created_at, likes: data.likes, photoURL: data.photoUrlForScreen)
        modalPhotoDetailVC.modalPresentationStyle = .fullScreen
        present(modalPhotoDetailVC, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
