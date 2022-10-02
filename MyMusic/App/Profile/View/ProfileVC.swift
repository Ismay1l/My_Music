//
//  ProfileVC.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 25.08.22.
//

import UIKit
import SDWebImage
import Shift
import RxSwift

class ProfileVC: UIViewController {
    
    //MARK: - Variables
    private let profileVM = ProfileVM()
    private var compositeDisposable = CompositeDisposable()
    private var disposeBag = DisposeBag()
    private var isConnectedToInternet = NetworkMonitor.shared.isConnected
    private var localProfile = [String]()
    
    //MARK: - UI Elements
    private lazy var profileTableView: UITableView = {
        let view = UITableView()
        view.isHidden = true
        view.backgroundColor = Asset.Colors.black.color
        view.delegate = self
        view.dataSource = self
        view.register(UITableViewCell.self, forCellReuseIdentifier: "\(UITableViewCell.self)")
        view.isScrollEnabled = false
        return view
    }()
    
    private lazy var profileImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 100
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.image = UIImage(systemName: "person.fill")
        return image
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.editButtonTitle, for: .normal)
        button.setTitleColor(Asset.Colors.white.color, for: .normal)
        button.titleLabel?.font = UIFont(name: "NotoSansMono-Medium", size: 18)
        button.backgroundColor = Asset.Colors.lightGray.color
        button.layer.cornerRadius = 8
        return button
    }()
    
    private lazy var planButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.planButtonTitle, for: .normal)
        button.setTitleColor(Asset.Colors.white.color, for: .normal)
        button.titleLabel?.font = UIFont(name: "NotoSansMono-Medium", size: 18)
        button.backgroundColor = Asset.Colors.lightGray.color
        button.layer.cornerRadius = 8
        return button
    }()
    
    //MARK: - Parent Delegate
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.Colors.black.color
        
        if isConnectedToInternet {
            observeData()
        } else {
            loadDataFromLocalDB()
        }
        
        configureConstraints()
        configureBarButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        compositeDisposable = CompositeDisposable()
        compositeDisposable.disposed(by: disposeBag)
    }
    
    //MARK: - Functions
    private func configureConstraints() {
        view.addSubview(profileTableView)
        view.addSubview(profileImage)
        view.addSubview(editButton)
        view.addSubview(planButton)
        
        let top = view.safeAreaLayoutGuide.snp.top
        let left = view.safeAreaLayoutGuide.snp.left
        let right = view.safeAreaLayoutGuide.snp.right
        let bottom = view.safeAreaLayoutGuide.snp.bottom
        let centerX = view.safeAreaLayoutGuide.snp.centerX
        
        profileImage.snp.makeConstraints { make in
            make.centerX.equalTo(centerX)
            make.top.equalTo(top).offset(20)
            make.width.height.equalTo(200)
        }
        
        editButton.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(10)
            make.left.equalTo(left).offset(50)
            make.width.equalTo(80)
        }
        
        planButton.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(10)
            make.right.equalTo(right).offset(-50)
            make.width.equalTo(80)
        }
        
        profileTableView.snp.makeConstraints { make in
            make.top.equalTo(editButton.snp.bottom).offset(20)
            make.left.equalTo(left).offset(20)
            make.right.equalTo(right).offset(-20)
            make.bottom.equalTo(bottom).offset(-10)
        }
    }
    
    private func loadDataFromLocalDB() {
        DispatchQueue.main.async {[weak self] in
            self?.profileTableView.isHidden = false
            self?.profileVM.getProfileData()
            guard let localDBProfile = self?.profileVM.localProfile else { return }
            self?.localProfile.append("\(L10n.fullnameLabel): \(localDBProfile.first?.name ?? "NA")")
            self?.localProfile.append("\(L10n.countryLabel): \(localDBProfile.first?.country ?? "NA")")
            self?.localProfile.append("\(L10n.productLabel): \(localDBProfile.first?.plan ?? "NA")")
            self?.localProfile.append("\(L10n.paymentCardLabel): \(1111) \(2222) \(3333) \(4444)")
            guard let urlStr = localDBProfile.first?.image, let url = URL(string: urlStr) else { return }
            self?.profileImage.sd_setImage(with: url)
            self?.profileTableView.reloadData()
        }
    }
    
    private func updateUI(with model: UserProfileResponse) {
        profileTableView.isHidden = false
        profileVM.model.removeAll()
        profileVM.model.append("\(L10n.fullnameLabel): \(model.displayName ?? "NA")")
        profileVM.model.append("\(L10n.countryLabel): \(model.country ?? "NA")")
        profileVM.model.append("\(L10n.productLabel): \(model.product ?? "NA")")
        profileVM.model.append("\(L10n.paymentCardLabel): \(1111) \(2222) \(3333) \(4444)")
        guard let urlStr = model.images?.first?.url, let url = URL(string: urlStr) else { return }
        profileImage.sd_setImage(with: url)
        profileVM.deleteAllProfile()
        profileVM.saveProfile(image: model.images?.first?.url ?? "NA",
                              name: model.displayName ?? "NA",
                              country: model.country ?? "NA",
                              plan: model.product ?? "NA")
        profileTableView.reloadData()
    }
    
    private func failedToGetProfile() {
        let label = UILabel()
        label.text = L10n.couldNotGetDataLabel
        label.textColor = .secondaryLabel
        label.sizeToFit()
        view.addSubview(label)
        label.center = view.center
    }
    
    private func didSignOut() {
        dismiss(animated: true)
        AuthManager.shared.signOut { [weak self] success in
            if success {
                DispatchQueue.main.async {
                    let vc = WelcomeVC()
                    vc.title = L10n.titleWelcomePage
                    vc.navigationItem.largeTitleDisplayMode = .always
                    let navVC = UINavigationController(rootViewController: vc)
                    navVC.navigationBar.prefersLargeTitles = true
                    navVC.modalPresentationStyle = .fullScreen
                    navVC.shift.enable()
                    navVC.shift.defaultAnimation = DefaultAnimations.Scale(.up)
                    navVC.shift.baselineDuration = 0.8
                    self?.present(navVC, animated: true) {
                        self?.navigationController?.popToRootViewController(animated: true)
                    }
                }
            }
        }
    }
    
    private func observeData() {
        let profileSubscription = profileVM.fetchUserProfileData()
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] received in
                guard let data = received.element else { return }
                switch data {
                case .showUserProfile(let model):
                    DispatchQueue.main.async {
                        self?.updateUI(with: model)
                        guard let userId = model.id else { return }
                        UserDefaultsManager.setString(value: userId, key: "user_id")
                    }
                }
            }
        let _ = compositeDisposable.insert(profileSubscription)
    }
    
    private func configureBarButtons() {
        let signOutButton = UIBarButtonItem(title: L10n.buttonSignOut, style: .plain, target: self, action: #selector(didTapBarButton(_:)))
        signOutButton.tintColor = Asset.Colors.mainBlue.color
        signOutButton.tag = 1
        navigationItem.leftBarButtonItem = signOutButton
        
        let notificationButton = UIBarButtonItem(image: UIImage(systemName: "bell.badge"), style: .plain, target: self, action: #selector(didTapBarButton(_:)))
        notificationButton.tintColor = Asset.Colors.mainBlue.color
        notificationButton.tag = 2
        navigationItem.rightBarButtonItem = notificationButton
    }
    
    @objc
    private func didTapBarButton(_ sender: UIBarButtonItem) {
        switch sender.tag {
        case 1:
            let alert = UIAlertController(title: L10n.titleSignOut, message: L10n.descriptionLabel, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: L10n.buttonCancel, style: .cancel))
            alert.addAction(UIAlertAction(title: L10n.buttonSignOut, style: .destructive, handler: {[weak self] _ in
                DispatchQueue.main.async {
                    self?.didSignOut()
                }
            }))
            present(alert, animated: true)
        case 2:
            print("Did tap notification button")
        default: break
        }
    }
}

//MARK: - Extension ProfileVC
extension ProfileVC: UITableViewDelegate,
                     UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isConnectedToInternet {
            return profileVM.model.count
        } else {
            return localProfile.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isConnectedToInternet {
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(UITableViewCell.self)", for: indexPath)
            cell.selectionStyle = .none
            cell.backgroundColor = Asset.Colors.lightGray.color
            cell.layer.cornerRadius = 12
            cell.clipsToBounds = true
            cell.layer.opacity = 0.5
            cell.textLabel?.textColor = Asset.Colors.white.color
            cell.textLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
            cell.textLabel?.text = profileVM.model[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(UITableViewCell.self)", for: indexPath)
            cell.selectionStyle = .none
            cell.backgroundColor = Asset.Colors.lightGray.color
            cell.layer.cornerRadius = 12
            cell.clipsToBounds = true
            cell.layer.opacity = 0.5
            cell.textLabel?.textColor = Asset.Colors.white.color
            cell.textLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
            cell.textLabel?.text = localProfile[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60 
    }
}
