//
//  SearchModel.swift
//  MyMusic
//
//  Created by USER11 on 9/9/22.
//

import Foundation

//MARK: - Categpries
struct CategoriesResponse: Codable {
    let categories: SearchCategory?
}

struct SearchCategory: Codable {
    let items: [CategoryItems]?
}

struct CategoryItems: Codable {
    let href: String?
    let icons: [APIImage]?
    let id: String?
    let name: String?
}
