//
//  FavoriteModel.swift
//  BroadAppsTestTask
//
//  Created by Elvis on 14.10.2022.
//

import Foundation
import RealmSwift

class FavoriteModel: Object {
    @objc dynamic var photoUrlForCell: String = ""
    @objc dynamic var photoUrlForScreen: String = ""
    @objc dynamic var authorName: String = ""
    @objc dynamic var created_at: String = ""
    @objc dynamic var likes: Int = 0
}
