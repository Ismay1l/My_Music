//
//  PlaySongPresenter.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 10.09.22.
//

import Foundation
import UIKit
import AVFoundation

final class PlaybackPresenter {
    
    static let shared = PlaybackPresenter()
    private init() {}
    
    //MARK: - Variables
    private var track: Track?
    private var tracks = [Track]()
    var player: AVPlayer?
    var playerQueue: AVQueuePlayer?
    
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
        playerVC.delegate = self
        viewController.present(UINavigationController(rootViewController: playerVC), animated: true) { [weak self] in
            self?.player?.play()
        }
    }
    
    func startPlaybackSongs(from viewController: UIViewController, tracks: [Track]) {
        self.tracks = tracks
        self.track = nil
        let playerVC = PlayerVC()
        playerVC.dataSource = self
        playerVC.delegate = self
        viewController.present(UINavigationController(rootViewController: playerVC), animated: true)
    }
}

//MARK: - Extension PlaybackPresenter
extension PlaybackPresenter: PlayerVCDataSource,
                             PlayerVCDelegate {
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
    
    func didTapPlay() {
        if let player = player {
            if player.timeControlStatus == .playing {
                player.pause()
            } else if player.timeControlStatus == .paused {
                player.play()
            }
        }
    }
    
    func didTapBack() {
        if tracks.isEmpty {
            player?.pause()
            player?.play()
        } else {
            
        }
    }
    
    func didTapForward() {
        if tracks.isEmpty {
            player?.pause()
        } else {
            
        }
    }
    
    func didChangeSliderValue(_ value: Float) {
        if let player = player {
            player.volume = value
        }
    }
}
 
