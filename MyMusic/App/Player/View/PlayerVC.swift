//
//  PlayerVC.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 25.08.22.
//

import UIKit

class PlayerVC: UIViewController {
    
    //MARK: - UI Elements
    private let imageView = ImageView()
    private let trackControllerView = TrackControllerView()

    //MARK: - Parent Delegate
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        
        configureConstraints()
    }
    
    //MARK: - Functions
    private func configureConstraints() {
        view.addSubview(imageView)
        view.addSubview(trackControllerView)
        
        let top = view.safeAreaLayoutGuide.snp.top
        let left = view.safeAreaLayoutGuide.snp.left
        let right = view.safeAreaLayoutGuide.snp.right
        let bottom = view.safeAreaLayoutGuide.snp.bottom
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(top)
            make.left.equalTo(left)
            make.right.equalTo(right)
            make.height.equalTo(view.frame.size.height / 2)
        }
        
        trackControllerView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.right.equalTo(right)
            make.left.equalTo(left)
            make.bottom.equalTo(bottom)
        }
    }
}
