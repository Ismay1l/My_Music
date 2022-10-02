//
//  SearchCategoriesCollectionViewCell.swift
//  MyMusic
//
//  Created by USER11 on 9/7/22.
//

import UIKit
import SDWebImage

class SearchGenreCollectionViewCell: UICollectionViewCell {
    
    //MARK: - UI Elements
    private lazy var iconImage: UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFill
        icon.tintColor = randomColors.randomElement()
        return icon
    }()
    
    private lazy var titleLabel = createLabel(textColor: Asset.Colors.white.color, fontSize: 18, fontName: "NotoSansMono-Medium")
    
    //MARK: - Parent Delegate
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: Parent Delegate
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
    
    //MARK: Functions
    private func setupUI() {
        contentView.addSubview(iconImage)
        contentView.addSubview(titleLabel)
        
        iconImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2)
            make.left.equalToSuperview().offset(2)
            make.right.equalToSuperview().offset(-2)
            make.bottom.equalToSuperview().offset(-2)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-8)
            make.left.equalToSuperview().offset(8)
        }
    }
    
    func configureCell(with item: CategoryItem) {
        titleLabel.text = item.name
        guard let urlStr = item.icons?.first?.url else { return }
        iconImage.sd_setImage(with: URL(string: urlStr), completed: nil)
        iconImage.tintColor = randomColors.randomElement()
        contentView.backgroundColor = randomColors.randomElement()
    }
    
    func configureCellWithLocalDB(with item: SearchCategory) {
        titleLabel.text = item.name
        guard let urlStr = item.icon else { return }
        iconImage.sd_setImage(with: URL(string: urlStr), completed: nil)
        iconImage.tintColor = randomColors.randomElement()
        contentView.backgroundColor = randomColors.randomElement()
    }
}
