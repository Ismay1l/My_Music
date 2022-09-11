//
//  ImageView.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 11.09.22.
//

import UIKit

class ImageView: UIView {
    
    //MARK: - UI Elements
    private lazy var trackImage: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .blue
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - Functions
    private func setupUI() {
        backgroundColor = .darkGray
        addSubview(trackImage)
        
        trackImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.left.equalToSuperview().offset(60)
            make.right.equalToSuperview().offset(-60)
            make.bottom.equalToSuperview().offset(-50)
        }
    }
}
