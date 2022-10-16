//
//  SearchingResult.swift
//  BroadAppsTestTask
//
//  Created by Elvis on 13.10.2022.
//

import Foundation

struct SearchingResult: Decodable {
    let total: Int
    let results: [UnsplashResult]
}

struct UnsplashResult: Decodable {
    let id: String
    let width: Int
    let height: Int
    let likes: Int
    let created_at: String
    let user: User
    let urls: [URLs.RawValue: String]
    
    enum URLs: String {
        case raw
        case full
        case regular
        case small
        case thumb
    }
}

struct User: Decodable {
    let name: String?
    let username: String?
}
