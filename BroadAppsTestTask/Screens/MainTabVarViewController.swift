//
//  ViewController.swift
//  BroadAppsTestTask
//
//  Created by Elvis on 12.10.2022.
//

import UIKit

final class MainTabVarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewControllers()
    }
}

private extension MainTabVarViewController {
    
    private func configureViewControllers() {
        let photoVC = PhotoViewController()
        let photoRootVC = UINavigationController(rootViewController: photoVC)
        photoRootVC.tabBarItem = UITabBarItem(
            title: "Photo",
            image: UIImage(systemName: "photo.on.rectangle.angled"),
            selectedImage: nil
        )
        
        let favoritePhotoVC = FavoritePhotoViewController()
        let favoriteRootVC = UINavigationController(rootViewController: favoritePhotoVC)
        favoriteRootVC.tabBarItem = UITabBarItem(
            title: "Favorite Photo",
            image: UIImage(systemName: "rectangle.stack.person.crop.fill"),
            selectedImage: nil
        )
        
        self.setViewControllers([photoRootVC, favoriteRootVC], animated: false)
    }
}

