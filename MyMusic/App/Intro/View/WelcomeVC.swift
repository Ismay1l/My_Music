//
//  WelcomeVC.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 25.08.22.
//

import UIKit
import Shift

class WelcomeVC: UIViewController {
    
    //MARK: - UI Elements
    private lazy var signInButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.titleWelcomeVCSigninLabel, for: .normal)
        button.setTitleColor(Asset.Colors.white.color, for: .normal)
        button.titleLabel?.font = UIFont(name: "NotoSansMono-Medium", size: 16)
        button.backgroundColor = Asset.Colors.mainBlue.color
        button.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        button.layer.cornerRadius = 12
        return button
    }()
    
    private lazy var wallpaperImage: UIImageView = {
        let image = UIImageView()
        image.image = Asset.Media.intoVCWalpaper.image
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private lazy var overLayView: UIView = {
        let view = UIView()
        view.backgroundColor = Asset.Colors.black.color
        view.alpha = 0.7
        return view
    }()
    
    private lazy var introLabel = createLabel(textColor: Asset.Colors.mainBlue.color, fontSize: 18, fontName: "NotoSansMono-Medium")

    //MARK: - Parent Delegate
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.Colors.black.color
        
        configureConstraints()
    }
    
    //MARK: - Functions
    private func configureConstraints() {
        view.addSubview(wallpaperImage)
        view.addSubview(overLayView)
        view.addSubview(signInButton)
        view.addSubview(introLabel)
        
        let left = view.safeAreaLayoutGuide.snp.left
        let right = view.safeAreaLayoutGuide.snp.right
        let bottom = view.safeAreaLayoutGuide.snp.bottom
        let center = view.safeAreaLayoutGuide.snp.center
        
        wallpaperImage.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.bottom.equalTo(view.snp.bottom)
            make.left.equalTo(left)
            make.right.equalTo(right)
        }
        
        overLayView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.bottom.equalTo(view.snp.bottom)
            make.left.equalTo(left)
            make.right.equalTo(right)
        }
        
        introLabel.text = L10n.exploreYourMusicWorldLabel
        introLabel.font = UIFont(name: "PassionsConflict-Regular", size: 50)
        introLabel.snp.makeConstraints { make in
            make.center.equalTo(center)
        }
        
        signInButton.snp.makeConstraints { make in
            make.bottom.equalTo(bottom).offset(-15)
            make.left.equalTo(left).offset(20)
            make.right.equalTo(right).offset(-20)
            make.height.equalTo(50)
        }
    }
    
    private func handleSignIn(success: Bool) {
        guard success else {
            let alert = UIAlertController(title: "Oops", message: "Error while signing in.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            present(alert, animated: true)
            return
        }
        
        let mainTabBarVC = TabBarController()
        mainTabBarVC.modalPresentationStyle = .fullScreen
        mainTabBarVC.shift.enable()
        mainTabBarVC.shift.defaultAnimation = DefaultAnimations.Scale(.down)
        mainTabBarVC.shift.baselineDuration = 0.8
        present(mainTabBarVC, animated: true)
    }
    
    @objc
    private func didTapSignIn() {
        let vc = SignInVC()
        vc.completion = { [weak self] result in
            DispatchQueue.main.async {
                self?.handleSignIn(success: result)
            }
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
