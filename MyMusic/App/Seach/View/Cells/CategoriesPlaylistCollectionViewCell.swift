//
//  CategoriesPlaylistCollectionViewCell.swift
//  MyMusic
//
//  Created by USER11 on 9/9/22.
//

import UIKit

class CategoriesPlaylistCollectionViewCell: UICollectionViewCell {
    
    //MARK: - UI Elements
    private lazy var albumCoverImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        return image
    }()
    
    private lazy var nameLabel = createLabel(textColor: Asset.Colors.white.color, fontSize: 14, fontName: "NotoSansMono-Medium")
    
    
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
        contentView.backgroundColor = Asset.Colors.black.color
        contentView.addSubview(albumCoverImage)
        contentView.addSubview(nameLabel)
        
        albumCoverImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalTo(contentView.frame.size.height - 30)
            make.width.equalTo(contentView.frame.size.width)
        }
        nameLabel.textAlignment = .center
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().offset(-8)
            make.right.equalToSuperview().offset(-2)
        }
    }
    
    func configureCell(with item: Item) {
        guard let urlStr = item.images?.first?.url else { return }
        albumCoverImage.sd_setImage(with: URL(string: urlStr), completed: nil)
        nameLabel.text = item.owner?.display_name
    }
}
