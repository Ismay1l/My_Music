//
//  SearchCategoriesCollectionViewCell.swift
//  MyMusic
//
//  Created by USER11 on 9/7/22.
//

import UIKit
import SDWebImage

class SearchGenreCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Variables
    let colors: [UIColor] = [
        .systemPurple,
        .systemRed,
        .systemBlue,
        .systemCyan,
        .systemFill,
        .systemGray,
        .systemMint,
        .systemPink,
        .systemTeal,
        .systemBrown,
        .systemGreen,
        .systemIndigo,
        .systemOrange,
        .systemYellow
    ]
    
    //MARK: - UI Elements
    private lazy var iconImage: UIImageView = {
        let icon = UIImageView(image: UIImage(systemName: "", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular)))
        icon.contentMode = .scaleToFill
        icon.tintColor = .white
        return icon
    }()
    
    private lazy var titleLabel = createLabel(textColor: .white, fontSize: 22, fontWeight: .semibold)
    
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
            make.top.equalToSuperview().offset(4)
            make.right.equalToSuperview().offset(-4)
            make.width.height.equalTo(60)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-8)
            make.left.equalToSuperview().offset(8)
        }
    }
    
    func configureCell(with item: CategoryItems) {
        titleLabel.text = item.name
        guard let urlStr = item.icons?.first?.url else { return }
        iconImage.sd_setImage(with: URL(string: urlStr), completed: nil)
        contentView.backgroundColor = colors.randomElement()
    }
}
