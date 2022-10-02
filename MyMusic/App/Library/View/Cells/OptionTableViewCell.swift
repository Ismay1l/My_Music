//
//  OptionTableViewCell.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 02.10.22.
//

import Foundation
import UIKit

class OptionTableViewCell: UITableViewCell {
    
    //MARK: - UI Elements
    private lazy var titleLabel = createLabel(textColor: Asset.Colors.white.color, fontSize: 16, fontName: "NotoSansMono-Medium")
    
    private lazy var iconImage: UIImageView = {
        let image = UIImageView()
        image.tintColor = Asset.Colors.mainBlue.color
        return image
    }()
    
    //MARK: - Parent Delegate
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - Parent Delegate
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
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
            make.left.equalToSuperview().offset(2)
            make.width.height.equalTo(25)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImage.snp.right).offset(10)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-5)
        }
    }
    
    func setUpCell(_ model: Option) {
        titleLabel.text = model.title
        iconImage.image = UIImage(systemName: model.icon)
    }
}
