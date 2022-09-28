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
    
    //MARK: - UI Elements
    private lazy var profileTableView: UITableView = {
        let view = UITableView()
        view.isHidden = true
        view.backgroundColor = Asset.Colors.black.color
        view.delegate = self
        view.dataSource = self
        view.register(UITableViewCell.self, forCellReuseIdentifier: "\(UITableViewCell.self)")
        return view
    }()
    
    //MARK: - Parent Delegate
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.Colors.black.color
        
        configureConstraints()
        observeData()
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
        
        let top = view.safeAreaLayoutGuide.snp.top
        let left = view.safeAreaLayoutGuide.snp.left
        let right = view.safeAreaLayoutGuide.snp.right
        let bottom = view.safeAreaLayoutGuide.snp.bottom
        
        profileTableView.snp.makeConstraints { make in
            make.top.equalTo(top).offset(10)
            make.left.equalTo(left).offset(20)
            make.right.equalTo(right).offset(-20)
            make.bottom.equalTo(bottom).offset(-10)
        }
    }
    
    private func updateUI(with model: UserProfileResponse) {
        profileTableView.isHidden = false
        profileVM.model.removeAll()
        profileVM.model.append("\(L10n.fullnameLabel): \(model.displayName ?? "NA")")
        profileVM.model.append("\(L10n.countryLabel): \(model.country ?? "NA")")
        profileVM.model.append("\(L10n.userIDLabel): \(model.id ?? "NA")")
        profileVM.model.append("\(L10n.productLabel): \(model.product ?? "NA")")
        profileVM.model.append("\(L10n.followerCountLabel): \(model.followers?.total ?? 0)")
        createHeaderForTableView(with: model.images?.first?.url ?? "NA")
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
    
    private func createHeaderForTableView(with urlString: String?) {
        guard let urlStr = urlString, let url = URL(string: urlStr) else { return }
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width / 1.5))
        let imageSize: CGFloat = headerView.frame.size.height / 2
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
        
        headerView.addSubview(imageView)
        imageView.center = headerView.center
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = imageSize / 2
        imageView.clipsToBounds = true
        
        imageView.sd_setImage(with: url, completed: nil)
        profileTableView.tableHeaderView = headerView
    }
    
    @objc
    private func DidTapSignOutButton() {
        let alert = UIAlertController(title: L10n.titleSignOut, message: L10n.descriptionLabel, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: L10n.buttonCancel, style: .cancel))
        alert.addAction(UIAlertAction(title: L10n.buttonSignOut, style: .destructive, handler: {[weak self] _ in
            DispatchQueue.main.async {
                self?.didSignOut()
            }
        }))
        present(alert, animated: true)
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
        let signOutButton = UIBarButtonItem(title: L10n.buttonSignOut, style: .plain, target: self, action: #selector(DidTapSignOutButton))
        signOutButton.tintColor = Asset.Colors.mainBlue.color
        navigationItem.leftBarButtonItem = signOutButton
    }
}

//MARK: - Extension ProfileVC
extension ProfileVC: UITableViewDelegate,
                     UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        profileVM.model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60 
    }
}
