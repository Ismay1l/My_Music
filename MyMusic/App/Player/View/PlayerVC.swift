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
    weak var delegate: PlayerVCDelegate?
    
    //MARK: - UI Elements
    private let imageView = ImageView()
    private let trackControllerView = TrackControllerView()
    
    private lazy var navigationBarHeader: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 10
        return view
    }()

    //MARK: - Parent Delegate
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        
        configureConstraints()
        configureData()
        trackControllerView.delegate = self
//        if self.isBeingDismissed {
//            delegate?.isDismissed()
//        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.isDismissed()
    }
    
    //MARK: - Functions
    private func configureConstraints() {
        view.addSubview(imageView)
        view.addSubview(trackControllerView)
        view.addSubview(navigationBarHeader)
        
        let top = view.safeAreaLayoutGuide.snp.top
        let left = view.safeAreaLayoutGuide.snp.left
        let right = view.safeAreaLayoutGuide.snp.right
        let bottom = view.safeAreaLayoutGuide.snp.bottom
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(navigationBarHeader.snp.bottom)
            make.left.equalTo(left)
            make.right.equalTo(right)
            make.height.equalTo((view.frame.size.height / 2) - 50)
        }
        
        trackControllerView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.right.equalTo(right)
            make.left.equalTo(left)
            make.bottom.equalTo(bottom)
        }
        
        navigationBarHeader.snp.makeConstraints { make in
            make.top.equalTo(top)
            make.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
            make.width.equalTo(80)
            make.height.equalTo(3)
        }
    }
    
    private func configureData() {
        imageView.trackImage.sd_setImage(with: dataSource?.imageURL, completed: nil)
        trackControllerView.titleLabel.text = dataSource?.trackName
        trackControllerView.artistLabel.text = dataSource?.artistName
    }
    
    func refreshUI() {
        configureData()
    }
}

//MARK: - Extension PlayerVC
extension PlayerVC: TrackControllerViewDelegate {
    func didTapPlayButton(_ playerController: TrackControllerView) {
        delegate?.didTapPlay()
    }
    
    func didTapBackButton(_ playerController: TrackControllerView) {
        delegate?.didTapBack()
    }
    
    func didTapForwardButton(_ playerController: TrackControllerView) {
        delegate?.didTapForward()
    }
    
    func didChangeSliderValue(_ playerController: TrackControllerView, value: Float) {
        delegate?.didChangeSliderValue(value)
    }
}
