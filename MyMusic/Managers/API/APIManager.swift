//
//  APIManager.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 25.08.22.
//

import Foundation
import Alamofire
import Promises

class APIManager: APIManagerProtocol {
    
    private var jsonDecoder = JSONDecoder()
    
    //MARK: - Header
    var header: HTTPHeaders {
        
        var header = HTTPHeaders()
        
        AuthManager.shared.getValidAccessToken { token in
            header["Authorization"] = "Bearer \(token)"
            header["Content-Type"] = "application/json"
            print("Token: \(token)")
        }
        return header
    }
    
    //MARK: - Fetch User Profile
    func fetchUserProfile() -> Promise<UserProfile> {
        let url = APIConstants.baseURL + "/me"
        let promise = Promise<UserProfile> { fulfill, reject in
            AF.request(url, method: .get, headers: self.header)
                .validate()
                .response { response in
                    guard let data = response.data else {
                        reject(APIError.failedToGetData)
                        return
                    }

                    if response.error != nil {
                        reject(APIError.failedToGetData)
                    }

                    do {
                        print("Data of Profile Result: \(data)")
                        let result = try self.jsonDecoder.decode(UserProfile.self, from: data)
                        fulfill(result)
                    } catch {
                        reject(error)
                    }
                }
        }
        return promise
    }
    
    //MARK: - Fetch Browse New Releases
    func fetchBrowseNewReleases() -> Promise<NewReleaseResponse> {
        let url = APIConstants.baseURL + "/browse/new-releases?limit=27"
        let promise = Promise<NewReleaseResponse> { fullfil, reject in
            AF.request(url, method: .get, headers: self.header)
                .validate()
                .response { response in
                    guard let data = response.data else {
                        reject(APIError.failedToGetData)
                        return
                    }
                    
                    if response.error != nil {
                        reject(APIError.failedToGetData)
                    }
                    
                    do {
                        print("Data of Browse Result: \(data)")
                        let result = try self.jsonDecoder.decode(NewReleaseResponse.self, from: data)
                        fullfil(result)
                    } catch {
                        reject(error)
                    }
                }
        }
        return promise
    }
    
    //MARK: Fetch Featured-Playlist
    func fetchFeaturedPlaylist() -> Promise<FeaturedPlaylistResponse> {
        let url = APIConstants.baseURL + "/browse/featured-playlists?limit=5"
        let promise = Promise<FeaturedPlaylistResponse> { fulfill, reject in
            AF.request(url, method: .get, headers: self.header)
                .validate()
                .response { response in
                    guard let data = response.data else {
                        reject(APIError.failedToGetData)
                        return
                    }
                    
                    if response.error != nil {
                        reject(APIError.failedToGetData)
                    }
                    
                    do {
                        print("Data of Featured Playlist: \(data)")
                        let result = try self.jsonDecoder.decode(FeaturedPlaylistResponse.self, from: data)
                        print("Count: \(result.playlists?.items?.count ?? 0)")
                        fulfill(result)
                    } catch {
                        reject(error)
                    }
                }
        }
        return promise
    }
    
    //MARK: - Fetch Recommended Genres
    func fetchRecommendedGenres() -> Promise<RecommendedGenreResponse> {
        let url = APIConstants.baseURL + "/recommendations/available-genre-seeds"
        let promise = Promise<RecommendedGenreResponse> { fulfill, reject in
            AF.request(url, method: .get, headers: self.header)
                .validate()
                .response { response in
                    guard let data = response.data else {
                        reject(APIError.failedToGetData)
                        return
                    }
                    
                    if response.error != nil {
                        reject(APIError.failedToGetData)
                    }
                    
                    do {
                        print("Data of Recommended Genres: \(data)")
                        let result = try self.jsonDecoder.decode(RecommendedGenreResponse.self, from: data)
                        fulfill(result)
                    } catch {
                        reject(error)
                    }
                }
        }
        return promise
    }
    
   //MARK: - Fetch Recommendations
    func fetchRecommendations(genres: Set<String>) -> Promise<RecommendationsResponse> {
        let seeds = genres.joined(separator: ",")
        let url = APIConstants.baseURL + "/recommendations?limit=27&seed_genres=\(seeds)"
        let promise = Promise<RecommendationsResponse> { fulfill, reject in
            AF.request(url, method: .get, headers: self.header)
                .validate()
                .response { response in
                    guard let data = response.data else {
                        reject(APIError.failedToGetData)
                        return
                    }
                    
                    if response.error != nil {
                        reject(APIError.failedToGetData)
                    }
                    
                    do {
                        print("Data of recommendations: \(data)")
                        let result = try self.jsonDecoder.decode(RecommendationsResponse.self, from: data)
                        fulfill(result)
                    } catch {
                        reject(error)
                    }
                }
        }
        return promise
    }
    
    //MARK: - Fetch Album Details
    func fetchAlbumDetails(album: Album) -> Promise<AlbumDetailResponse> {
        let promise = Promise<AlbumDetailResponse> { fulfill, reject in
            guard let id = album.id else { return }
            let url = APIConstants.baseURL + "/albums/\(id)"
            AF.request(url, method: .get, headers: self.header)
                .validate()
                .response { response in
                    guard let data = response.data else {
                        reject(APIError.failedToGetData)
                        return
                    }
                    
                    if response.error != nil {
                        reject(APIError.failedToGetData)
                    }
                    
                    do {
                        print("Data of album details: \(data)")
                        let result = try self.jsonDecoder.decode(AlbumDetailResponse.self, from: data)
                        fulfill(result)
                    } catch {
                        reject(error)
                    }
                }
        }
        return promise
    }
    
    //MARK: - Fetch Playlists
    func fetchPlaylists(playlist: FeaturedPlaylistItem) -> Promise<PlaylistResponse> {
        let promise = Promise<PlaylistResponse> { fulfill, reject in
            guard let id = playlist.id else { return }
            let url = APIConstants.baseURL + "/playlists/\(id)"
            AF.request(url, method: .get, headers: self.header)
                .validate()
                .response { response in
                    guard let data = response.data else {
                        reject(APIError.failedToGetData)
                        return
                    }
                    
                    if response.error != nil {
                        reject(APIError.failedToGetData)
                    }
                    
                    do {
                        print("Data of Playlists: \(data)")
                        let result = try self.jsonDecoder.decode(PlaylistResponse.self, from: data)
                        fulfill(result)
                    } catch {
                        reject(error)
                    }
                }
        }
        return promise
    }
}
