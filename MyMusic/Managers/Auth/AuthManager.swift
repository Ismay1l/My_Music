//
//  AuthManager.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 25.08.22.
//

import Foundation
import Alamofire

class AuthManager {
    
    static let shared = AuthManager()
    private init() {}
    
    private var refreshingToken = false
    
    public var signInURL: URL? {
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(AccessCredentials.clientID)&scope=\(AccessCredentials.scopes)&redirect_uri=\(AccessCredentials.redirectURI)&show_dialog=TRUE"
        
        return URL(string: string)
    }
    
    //MARK: - Checks if user is signed in
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    private var accessToken: String? {
        return APPDefaultsManager.getString(key: "access_token")
    }
    
    private var refreshToken: String? {
        return APPDefaultsManager.getString(key: "refresh_token")
    }
    
    private var tokenExpirationDate: Date? {
        return APPDefaultsManager.getDate(key: "expiration_date")
    }
    
    //MARK: - Checks if accessToken needs to be refreshed
    private var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else {
            return false
        }
        
        let currentDate = Date()
        let threeMinutes: TimeInterval = 180
        return currentDate.addingTimeInterval(threeMinutes) >= expirationDate
    }
    
    private var onRefreshBlock = [((String) -> Void)]()
    
    //MARK: - To get valid (refreshed if needed) accessToken for API calls
    public func getValidAccessToken(completion: @escaping (String) -> Void) {
        
        guard !refreshingToken else {
            onRefreshBlock.append(completion)
            return
        }
        
        if shouldRefreshToken {
            refreshAccessToken { [weak self] result in
                if result {
                    if let token = self?.accessToken {
                        completion(token)
                    }
                }
            }
        } else {
            if let token = accessToken {
                completion(token)
            }
        }
    }
    
    //MARK: - To get tokens
    public func getTokens(code: String, completion: @escaping (Bool) -> Void) {
        
        guard let url = URL(string: AccessCredentials.tokenAPIURL) else { return }
        
        let params = [
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": AccessCredentials.redirectURI
        ]
        
        let basicToken = AccessCredentials.clientID+":"+AccessCredentials.clientSecret
        let tokenData = basicToken.data(using: .utf8)
        guard let base64String = tokenData?.base64EncodedString() else {
            completion(false)
            print("Failed to converto to base64 format")
            return
        }
        
        
        print("Base64: \(base64String)")
        let headers: HTTPHeaders = [
            "Authorization": "Basic \(base64String)",
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        AF.request(url, method: .post, parameters: params, headers: headers)
            .validate()
            .response { [weak self] response in
                
                self?.refreshingToken = false
                
                guard let data = response.data else {
                    completion(false)
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                    print("AccessTokenRRR: \(result.accessToken ?? "NA")")
                    print("AuthResponse: \(result)")
                    self?.onRefreshBlock.forEach({ string in
                        if let token = result.accessToken {
                            string(token)
                        }
                    })
                    self?.onRefreshBlock.removeAll()
                    self?.cacheToken(result: result)
                    completion(true)
                } catch {
                    print("Error of decoding: \(error.localizedDescription)")
                    completion(false)
                }
            }
    }
    
    //MARK: - To refresh accessToken
    public func refreshAccessToken(completion: ((Bool) -> Void)?) {
        
        guard !refreshingToken else {
            return
        }
        
        guard shouldRefreshToken else {
            completion?(true)
            return
        }
        
        guard let refreshToken = refreshToken else {
            print("RefreshToken: \(refreshToken ?? "NA")")
            return
        }
        
        guard let url = URL(string: AccessCredentials.tokenAPIURL) else { return }
        
        refreshingToken = true
        
        let params = [
            "grant_type": "refresh_token",
            "refresh_token": refreshToken
        ]
        
        let basicToken = AccessCredentials.clientID+":"+AccessCredentials.clientSecret
        let tokenData = basicToken.data(using: .utf8)
        guard let base64String = tokenData?.base64EncodedString() else {
            completion?(false)
            print("Failed to converto to base64 format")
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Basic \(base64String)",
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        tokenRequest(url: url, method: .post, parameters: params, headers: headers) { success in
            completion? (success)
        }
    }
    
    private func tokenRequest(url: URL, method: HTTPMethod, parameters: Parameters, headers: HTTPHeaders, completion: @escaping (Bool) -> Void) {
        AF.request(url, method: method, parameters: parameters, headers: headers)
            .validate()
            .response { [weak self] response in
                
                self?.refreshingToken = false
                
                guard let data = response.data else {
                    completion(false)
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                    print("AccessTokenRRR: \(result.accessToken ?? "NA")")
                    self?.onRefreshBlock.forEach({ string in
                        if let token = result.accessToken {
                            string(token)
                        }
                    })
                    self?.onRefreshBlock.removeAll()
                    self?.cacheToken(result: result)
                    completion(true)
                } catch {
                    print("Error of decoding: \(error.localizedDescription)")
                    completion(false)
                }
            }
    }
    
    //MARK: - To cache tokens
    private func cacheToken(result: AuthResponse) {
        APPDefaultsManager.setString(value: result.accessToken ?? "NA", key: "access_token")
        
        if let refreshToken = result.refreshToken {
            APPDefaultsManager.setString(value: refreshToken, key: "refresh_token")
        }
        
        APPDefaultsManager.setDate(value: Date().addingTimeInterval(TimeInterval(result.expiresIn ?? 0)), key: "expiration_date")
    }
    
    //MARK: To sign out
    public func signOut(completion: @escaping (Bool) -> Void) {
        APPDefaultsManager.removeObject(key: "access_token")
        APPDefaultsManager.removeObject(key: "refresh_token")
        APPDefaultsManager.removeObject(key: "expiration_date")
        completion(true)
    }
}


