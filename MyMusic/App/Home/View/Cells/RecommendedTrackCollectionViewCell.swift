//
//  RecommendedTrackCollectionViewCell.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 02.09.22.
//

import UIKit

class RecommendedTrackCollectionViewCell: UICollectionViewCell {
    
    //MARK: UI Elements
    private lazy var albumCoverImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 8
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var trackNameLabel = createLabel(textColor: Asset.Colors.white.color, fontSize: 16, fontName: "NotoSansMono-Medium")
    private lazy var artistNameLabel = createLabel(textColor: Asset.Colors.secondaryBlack.color, fontSize: 14, fontName: "NotoSansMono-Medium")
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: Parent Delegate
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    //MARK: Functions
    private func setupUI() {
        contentView.backgroundColor = Asset.Colors.lightGray.color
        contentView.addSubview(albumCoverImage)
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistNameLabel)
        
        albumCoverImage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(3)
            make.top.equalToSuperview().offset(3)
            make.bottom.equalToSuperview().offset(-3)
            make.width.equalTo(contentView.frame.size.height - 6)
        }
        
        trackNameLabel.snp.makeConstraints { make in
            make.left.equalTo(albumCoverImage.snp.right).offset(8)
            make.top.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-3)
        }
        
        artistNameLabel.snp.makeConstraints { make in
            make.left.equalTo(albumCoverImage.snp.right).offset(8)
            make.bottom.equalToSuperview().offset(-5)
            make.right.equalToSuperview().offset(-3)
        }
    }
    
    func configureCell(item: Track) {
        guard let url = item.album?.images?.first?.url else { return }
        albumCoverImage.sd_setImage(with: URL(string: url), completed: nil)
        trackNameLabel.text = item.name
        artistNameLabel.text = item.artists?.first?.name
    }
}
