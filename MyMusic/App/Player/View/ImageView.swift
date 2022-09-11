//
//  ImageView.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 11.09.22.
//

import UIKit

class ImageView: UIView {
    
    //MARK: - UI Elements
    lazy var trackImage: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .blue
        view.layer.cornerRadius = 12
        view.clipsToBounds = false
        view.layer.shadowRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = CGSize(width: 20, height: 20)
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
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(60)
            make.right.equalToSuperview().offset(-60)
            make.bottom.equalToSuperview().offset(-90)
        }
    }
}
