//
//  BrowseAlbumsHeaderView.swift
//  MyMusic
//
//  Created by USER11 on 9/7/22.
//

import UIKit

class BrowseAlbumsHeaderView: UICollectionReusableView {
    
    //MARK: - UI Elements
    private lazy var playlistImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 8
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var playlistNameLabel = createLabel(textColor: Asset.Colors.white.color, fontSize: 24, fontName: "NotoSansMono-Bold")
    private lazy var releaseDateLabel = createLabel(textColor: Asset.Colors.secondaryBlack.color, fontSize: 14, fontName: "NotoSansMono-Medium")
    private lazy var trackCountLabel = createLabel(textColor: Asset.Colors.secondaryBlack.color, fontSize: 14, fontName: "NotoSansMono-Medium")
        
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
        addSubview(releaseDateLabel)
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
}
