//
//  BrowseAlbumsCollectionViewCell.swift
//  MyMusic
//
//  Created by USER11 on 9/7/22.
//

import UIKit

class BrowseAlbumsCollectionViewCell: UICollectionViewCell {
    
    //MARK: UI Elements
    private lazy var artistNameLabel = createLabel(textColor: Asset.Colors.white.color, fontSize: 14, fontWeight: "NotoSansMono-Regular")
    private lazy var albumNameLabel = createLabel(textColor: Asset.Colors.white.color, fontSize: 16, fontWeight: "NotoSansMono-Medium")
    
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
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(artistNameLabel)
        
        artistNameLabel.textAlignment = .center
        artistNameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(8)
            make.top.equalToSuperview().offset(3)
        }
        
        albumNameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func configureCell(item: Track) {
        artistNameLabel.text = item.artists?.first?.name
        albumNameLabel.text = item.name
    }
}
