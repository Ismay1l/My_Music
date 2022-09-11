//
//  PlaySongPresenter.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 10.09.22.
//

import Foundation
import UIKit
import SPStorkController
import AVFoundation

final class PlaybackPresenter {
    
    static let shared = PlaybackPresenter()
    private init() {}
    
    //MARK: - Variables
    private var track: Track?
    private var tracks = [Track]()
    var player: AVPlayer?
    
    var currentTrack: Track? {
        if let track = track, tracks.isEmpty {
            return track
        } else if !tracks.isEmpty {
            return tracks.first
        }
        return nil
    }
    
    //MARK: - Functions
    func startPlaybackSong(from viewController: UIViewController, track: Track) {
        guard let url = URL(string: track.preview_url ?? "") else { return }
        player = AVPlayer(url: url)
        player?.volume = 0.5
        self.track = track
        self.tracks = []
        let playerVC = PlayerVC()
        playerVC.dataSource = self
        viewController.present(UINavigationController(rootViewController: playerVC), animated: true) { [weak self] in
            self?.player?.play()
        }
    }
    
    func startPlaybackSongs(from viewController: UIViewController, tracks: [Track]) {
        self.tracks = tracks
        self.track = nil
        let playerVC = PlayerVC()
        playerVC.dataSource = self
        viewController.present(UINavigationController(rootViewController: playerVC), animated: true)
    }
}

//MARK: - Extension PlaybackPresenter
extension PlaybackPresenter: PlayerVCDataSource {
    var trackName: String? {
        currentTrack?.name
    }
    
    var artistName: String? {
        currentTrack?.artists?.first?.name
    }
    
    var imageURL: URL? {
        if let urlStr = currentTrack?.album?.images?.first?.url {
            return URL(string: urlStr)
        }
        return nil
    }
}
 
