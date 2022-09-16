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
    var playerVC: PlayerVC?
    var index = 0
    
    var currentTrack: Track? {
        if let track = track, tracks.isEmpty {
            return track
        } else if let _ = playerQueue, !tracks.isEmpty {
            return tracks[index]
        }
        return nil
    }
    
    //MARK: - Functions
    func startPlaybackSong(from viewController: UIViewController, track: Track, tracks: [Track?]) {
        guard let url = URL(string: track.preview_url ?? "") else { return }
        player = AVPlayer(url: url)
        player?.volume = 0.5
        self.track = track
//        self.tracks = []
        let playerVC = PlayerVC()
        playerVC.dataSource = self
        playerVC.delegate = self
        viewController.present(UINavigationController(rootViewController: playerVC), animated: true) { [weak self] in
            self?.player?.play()
        }
        self.playerVC = playerVC
    }
    
    func startPlaybackSongs(from viewController: UIViewController, tracks: [Track]) {
        self.tracks = tracks
        self.track = nil
        let items: [AVPlayerItem] = tracks.compactMap { track in
            guard let url = URL(string: track.preview_url ?? "NA") else { return nil }
            return AVPlayerItem(url: url)
        }
        playerQueue = AVQueuePlayer(items: items)
        playerQueue?.volume = 0.5
        playerQueue?.play()
        let playerVC = PlayerVC()
        playerVC.dataSource = self
        playerVC.delegate = self
        viewController.present(UINavigationController(rootViewController: playerVC), animated: true)
        self.playerVC = playerVC
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
        else if let player = playerQueue {
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
        } else if let firstItem = playerQueue?.items().first {
            playerQueue?.pause()
            playerQueue?.removeAllItems()
            playerQueue = AVQueuePlayer(items: [firstItem])
            playerQueue?.play()
            player?.volume = 0.5
        }
    }
    
    func didTapForward() {
        if tracks.isEmpty {
            player?.pause()
        } else if let player = playerQueue {
            player.advanceToNextItem()
            index += 1
            playerVC?.refreshUI()
        }
    }
    
    func didChangeSliderValue(_ value: Float) {
        if let player = player {
            player.volume = value
        }
    }
}
 
