//
//  PlayerVC.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 25.08.22.
//

import UIKit
import SDWebImage

class PlayerVC: UIViewController {
    
    //MARK: - Variables
    weak var dataSource: PlayerVCDataSource?
    
    //MARK: - UI Elements
    private let imageView = ImageView()
    private let trackControllerView = TrackControllerView()

    //MARK: - Parent Delegate
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        
        configureConstraints()
        configureData()
        trackControllerView.delegate = self
    }
    
    //MARK: - Functions
    private func configureConstraints() {
        view.addSubview(imageView)
        view.addSubview(trackControllerView)
        
        let top = view.safeAreaLayoutGuide.snp.top
        let left = view.safeAreaLayoutGuide.snp.left
        let right = view.safeAreaLayoutGuide.snp.right
        let bottom = view.safeAreaLayoutGuide.snp.bottom
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(top)
            make.left.equalTo(left)
            make.right.equalTo(right)
            make.height.equalTo(view.frame.size.height / 2)
        }
        
        trackControllerView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.right.equalTo(right)
            make.left.equalTo(left)
            make.bottom.equalTo(bottom)
        }
    }
    
    private func configureData() {
        imageView.trackImage.sd_setImage(with: dataSource?.imageURL, completed: nil)
        trackControllerView.titleLabel.text = dataSource?.trackName
        trackControllerView.artistLabel.text = dataSource?.artistName
    }
}

//MARK: - Extension PlayerVC
extension PlayerVC: TrackControllerViewDelegate {
    func didTapPlayButton(_ playerController: TrackControllerView) {
        print("Play tapped")
    }
    
    func didTapBackButton(_ playerController: TrackControllerView) {
        print("Back tapped")
    }
    
    func didTapForwardButton(_ playerController: TrackControllerView) {
        print("Forward tapped")
    }
}
