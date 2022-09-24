//
//  AlertView.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 9/19/22.
//

import UIKit

class AlertView: UIView {
    
    weak var delegate: AlertViewDelegate?
    
    //MARK: - UI Elements
    private lazy var alertLabel = createLabel(textColor: .systemRed, fontSize: 16, fontWeight: .medium)
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create a Playlist", for: .normal)
        button.setTitleColor(UIColor.link, for: .normal)
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Parent Delegate
    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - Functions
    private func setUpUI() {
        addSubview(alertLabel)
        addSubview(createButton)
        
        alertLabel.text = "There is no playlist yet"
        alertLabel.numberOfLines = 0
        
        alertLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
        }
        
        createButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
    }
    
    @objc
    private func didTapButton(_ sender: UIButton) {
        delegate?.alertViewButtonTapped(self)
    }
}
