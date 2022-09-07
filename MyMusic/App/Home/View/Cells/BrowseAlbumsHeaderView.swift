//
//  BrowseAlbumsHeaderView.swift
//  MyMusic
//
//  Created by USER11 on 9/7/22.
//

import UIKit

class BrowseAlbumsHeaderView: UICollectionReusableView {
    
    weak var delegate: BrowseAlbumsHeaderViewDelegate?
    
    //MARK: - UI Elements
    private lazy var playlistImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 8
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var playlistNameLabel = createLabel(textColor: .white, fontSize: 24, fontWeight: .bold)
    private lazy var releaseDateLabel = createLabel(textColor: .darkGray, fontSize: 14, fontWeight: .semibold)
    private lazy var trackCountLabel = createLabel(textColor: .darkGray, fontSize: 14, fontWeight: .semibold)
    
    private lazy var playButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemRed
        let image = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 3, weight: UIImage.SymbolWeight.regular))
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 30
        button.addTarget(self, action: #selector(didTapPlay), for: .touchUpInside)
        return button
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - Functions
    private func setupUI() {
        backgroundColor = hexStringToUIColor(hex: "370617")
        
        addSubview(playlistImage)
        addSubview(playlistNameLabel)
        addSubview(releaseDateLabel)
        addSubview(playButton)
        addSubview(trackCountLabel)
        
        playlistImage.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(220)
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        playlistNameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(5)
            make.top.equalTo(playlistImage.snp.bottom).offset(13)
        }
        
        playButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
            make.width.height.equalTo(60)
        }
        
        releaseDateLabel.numberOfLines = 0
        releaseDateLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.top.equalTo(playlistNameLabel.snp.bottom).offset(10)
        }
        
        trackCountLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(5)
            make.top.equalTo(releaseDateLabel.snp.bottom).offset(10)
        }
    }
    
    func configureHeader(item: Album) {
        guard let url = item.images?.first?.url else { return }
        playlistImage.sd_setImage(with: URL(string: url), completed: nil)
        playlistNameLabel.text = item.name
        releaseDateLabel.text = "Release date: \(item.release_date ?? "NA")"
        trackCountLabel.text = "Total tracks: \(item.total_tracks ?? 0)"
    }
    
    @objc
    private func didTapPlay() {
        delegate?.didTapPlayButton(self)
    }
}
