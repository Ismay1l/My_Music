//
//  LibrarySwitchView.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 18.09.22.
//

import UIKit

class LibrarySwitchView: UIView {
    
    //MARK: - Variables
    weak var delegate: LibrarySwitchViewDelegate?
    var state: SwitchLibraryVCState = .playlist
    
    //MARK: - UI Elements
    private lazy var playlistButton: UIButton = {
        let button = UIButton()
        button.setTitle("Playlist", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(Asset.Colors.white.color, for: .normal)
        button.tag = 1
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var albumButton: UIButton = {
        let button = UIButton()
        button.setTitle("Album", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(Asset.Colors.white.color, for: .normal)
        button.tag = 2
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var underIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - Functions
    private func setUpUI() {
        addSubview(playlistButton)
        addSubview(albumButton)
        addSubview(underIndicatorView)
        
        playlistButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(60)
            make.top.equalToSuperview()
        }
        
        albumButton.snp.makeConstraints { make in
            make.left.equalTo(self.snp.centerX).offset(60)
            make.top.equalToSuperview()
        }
        
        setUpUnderIndicatorView()
    }
    
    private func setUpUnderIndicatorView() {
        switch state {
        case .playlist:
            underIndicatorView.frame = CGRect(x: 0,
                                              y: 38,
                                              width: 150,
                                              height: 3)
        case .album:
            underIndicatorView.frame = CGRect(x: self.frame.size.width / 2,
                                              y: 38,
                                              width: 150,
                                              height: 3)
        }
    }
    
    func updateIndicator(_for state: SwitchLibraryVCState) {
        self.state = state
        UIView.animate(withDuration: 0.2) {
            self.setUpUnderIndicatorView()
        }
    }
    
    @objc
    private func didTapButton(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            state = .playlist
            UIView.animate(withDuration: 0.2) {
                self.setUpUnderIndicatorView()
            }
            delegate?.switchToPlaylistVC(self)
        case 2:
            state = .album
            UIView.animate(withDuration: 0.2) {
                self.setUpUnderIndicatorView()
            }
            delegate?.switchToAlbumVC(self)
        default: break
        }
    }
}
