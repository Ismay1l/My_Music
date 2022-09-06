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
        button.setTitleColor(hexStringToUIColor(hex: "03071e"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = hexStringToUIColor(hex: "fdf0d5")
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
        view.backgroundColor = .black
        view.alpha = 0.7
        return view
    }()

    //MARK: - Parent Delegate
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = hexStringToUIColor(hex: "6a040f")
        
        configureConstraints()
    }
    
    //MARK: - Functions
    private func configureConstraints() {
        view.addSubview(wallpaperImage)
        view.addSubview(overLayView)
        view.addSubview(signInButton)
        
        let left = view.safeAreaLayoutGuide.snp.left
        let right = view.safeAreaLayoutGuide.snp.right
        let bottom = view.safeAreaLayoutGuide.snp.bottom
        
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
        
        signInButton.snp.makeConstraints { make in
            make.bottom.equalTo(bottom).offset(-15)
            make.left.equalTo(left).offset(20)
            make.right.equalTo(right).offset(-20)
            make.height.equalTo(50)
        }
    }
    
    @objc private func didTapSignIn() {
        let vc = SignInVC()
        vc.completion = { [weak self] result in
            DispatchQueue.main.async {
                self?.handleSignIn(success: result)
            }
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleSignIn(success: Bool) {
        guard success else {
            let alert = UIAlertController(title: "Oops", message: "Error while signing in.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            present(alert, animated: true)
            return
        }
        
        let mainTabBarVC = CustomTabBarController()
        mainTabBarVC.modalPresentationStyle = .fullScreen
        mainTabBarVC.shift.enable()
        mainTabBarVC.shift.defaultAnimation = DefaultAnimations.Scale(.down)
        mainTabBarVC.shift.baselineDuration = 0.8
        present(mainTabBarVC, animated: true)
    }
}
