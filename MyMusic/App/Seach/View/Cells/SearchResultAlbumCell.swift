//
//  SearchResultAlbumCell.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 17.09.22.
//

import UIKit
import SDWebImage

class SearchResultAlbumCell: UITableViewCell {
    
    //MARK: - UI Elements
    private lazy var titleLabel = createLabel(textColor: .white, fontSize: 16, fontWeight: .medium)
    private lazy var subtitleLabel = createLabel(textColor: .white, fontSize: 12, fontWeight: .regular )
    
    private lazy var iconImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 8
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
        contentView.addSubview(subtitleLabel)
        
        iconImage.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.height.equalTo(40)
            make.centerY.equalToSuperview()
            make.width.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImage.snp.right).offset(10)
            make.top.equalToSuperview().offset(2)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImage.snp.right).offset(10)
            make.bottom.equalToSuperview().offset(-2)
        }
    }
    
    func configure(_with model: SearchResultAlbumTableViewModel) {
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
        guard let url = model.imageURL else { return }
        iconImage.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo"), completed: nil)
    }
}
