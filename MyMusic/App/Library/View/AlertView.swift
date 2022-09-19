//
//  AlertView.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 9/19/22.
//

import UIKit

class AlertView: UIView {
    
    //MARK: - UI Elements
    private lazy var alertLabel = createLabel(textColor: .systemRed, fontSize: 16, fontWeight: .medium)
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create a Playlist", for: .normal)
        button.setTitleColor(<#T##color: UIColor?##UIColor?#>, for: <#T##UIControl.State#>)
        return button
    }()
    
    //MARK: - Parent Delegate
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - Functions
}
