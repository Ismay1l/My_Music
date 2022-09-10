//
//  PlaySongPresenter.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 10.09.22.
//

import Foundation
import UIKit
import SPStorkController

final class PlaybackPresenter {
    
    static let shared = PlaybackPresenter()
    private init() {}
    
    func startPlaybackSong(from viewController: UIViewController, song: Track) {
        let playerVC = PlayerVC()
        viewController.presentAsStork(playerVC)
    }
    
    func startPlaybackSongs(from viewController: UIViewController, songs: [Track]) {
        let playerVC = PlayerVC()
        viewController.presentAsStork(playerVC)
    }
}
 
