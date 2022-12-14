//
//  NewReleaseCollectionViewCell.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 02.09.22.
//

import UIKit
import SDWebImage

class NewReleaseCollectionViewCell: UICollectionViewCell {
    
    //MARK: - UI Elements
    private lazy var albumCoverImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        return image
    }()
    
    private lazy var albumNameLabel = createLabel(textColor: .black, fontSize: 14, fontWeight: .semibold)
    private lazy var artistNameLabel = createLabel(textColor: .gray, fontSize: 12, fontWeight: .semibold)
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - Parent Delegate
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    //MARK: Functions
    private func setupUI() {
        contentView.backgroundColor = hexStringToUIColor(hex: "d3d3d3")
        contentView.addSubview(albumCoverImage)
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(artistNameLabel)
        
        albumCoverImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview().offset(-27)
            make.width.equalTo(contentView.frame.size.width)
        }
        
        artistNameLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(4)
        }

        albumNameLabel.snp.makeConstraints { make in
            make.top.equalTo(albumCoverImage.snp.bottom)
            make.left.equalToSuperview().offset(4)
            make.right.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumCoverImage.sd_setImage(with: nil, completed: nil)
        albumNameLabel.text = nil
        artistNameLabel.text = nil
    }
    
    func configureCell(item: Album) {
        guard let url = item.images?.first?.url else { return }
        albumCoverImage.sd_setImage(with: URL(string: url), completed: nil)
        albumNameLabel.text = item.name
        artistNameLabel.text = item.artists?.first?.name
    }
}
