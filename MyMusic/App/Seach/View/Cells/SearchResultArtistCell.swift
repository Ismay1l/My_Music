//
//  SearchResultBasicCell.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 17.09.22.
//

import UIKit
import SDWebImage

class SearchResultArtistCell: UITableViewCell {
    
    //MARK: - UI Elements
    private lazy var titleLabel = createLabel(textColor: Asset.Colors.white.color, fontSize: 16, fontWeight: "NotoSansMono-Medium")
    
    private lazy var iconImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 20 
        image.clipsToBounds = true
        return image
    }()
    
    //MARK: - Parent Delegate
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        iconImage.sd_setImage(with: nil, completed: nil)
    }
    
    //MARK: - Functions
    private func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(iconImage)
        
        iconImage.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.height.equalTo(40)
            make.centerY.equalToSuperview()
            make.width.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImage.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(_with model: SearchResultArtistTableViewModel) {
        titleLabel.text = model.title
        guard let url = model.imageURL else { return }
        iconImage.sd_setImage(with: url, completed: nil)
    }
}
