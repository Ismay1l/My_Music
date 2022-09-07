//
//  MainCollectionHeaderView.swift
//  MyMusic
//
//  Created by USER11 on 9/7/22.
//

import UIKit

class MainCollectionHeaderView: UICollectionReusableView {
    
    //MARK: - UI Elements
    private lazy var titleLabel = createLabel(textColor: .white, fontSize: 18, fontWeight: .semibold)
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - Functions
    private func setupUI() {
        backgroundColor = hexStringToUIColor(hex: "370617")
        
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
    }
    
    func configureHeader(_with title: String) {
        titleLabel.text = title
    }
}
