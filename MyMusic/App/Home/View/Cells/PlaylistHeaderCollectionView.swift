//
//  PlaylistHeaderCollectionView.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 05.09.22.
//

import UIKit

class PlaylistHeaderCollectionView: UICollectionReusableView {
    
    weak var delegate: PlaylistHeaderCollectionViewDelegate?
    private let playerVC = PlayerVC()
    
    //MARK: - UI Elements
    private lazy var playlistImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 8
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var playlistNameLabel = createLabel(textColor: Asset.Colors.white.color, fontSize: 24, fontWeight: "NotoSansMono-Bold")
    private lazy var descriptionLabel = createLabel(textColor: Asset.Colors.secondaryBlack.color, fontSize: 14, fontWeight: "NotoSansMono-Medium")
    
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
        backgroundColor = Asset.Colors.black.color
        
        addSubview(playlistImage)
        addSubview(playlistNameLabel)
        addSubview(descriptionLabel)
        addSubview(playButton)
        
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
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.top.equalTo(playlistNameLabel.snp.bottom).offset(10)
        }
    }
    
    func configureHeader(item: Item) {
        guard let url = item.images?.first?.url else { return }
        playlistImage.sd_setImage(with: URL(string: url), placeholderImage: UIImage(systemName: "photo"), completed: nil)
        playlistNameLabel.text = item.name
        descriptionLabel.text = item.owner?.display_name
    }
    
    @objc
    private func didTapPlay() {
        delegate?.didTapPlayButton(self)
    }
}
