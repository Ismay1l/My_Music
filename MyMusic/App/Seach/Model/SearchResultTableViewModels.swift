//
//  SearchResultTableViewModels.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 18.09.22.
//

import Foundation

//MARK: - SearchResult TableView Model
struct SearchSection {
    let title: String?
    let results: [SearchResult]?
}

//MARK: - SearchResult Artist TableView Model
struct SearchResultArtistTableViewModel {
    let title: String?
    let imageURL: URL?
}

//MARK: - SearchResult Album TableView Model
struct SearchResultAlbumTableViewModel {
    let title: String?
    let subtitle: String?
    let imageURL: URL?
}
