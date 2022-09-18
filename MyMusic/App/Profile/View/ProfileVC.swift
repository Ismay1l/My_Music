//
//  ProfileVC.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 25.08.22.
//

import UIKit
import SDWebImage
import Shift
import BLTNBoard
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
        view.backgroundColor = hexStringToUIColor(hex: "370617")
        view.delegate = self
        view.dataSource = self
        view.register(UITableViewCell.self, forCellReuseIdentifier: "\(UITableViewCell.self)")
        return view
    }()
    
    private lazy var signOutButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.titleAccountLabel, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.setTitleColor(UIColor.orange, for: .normal)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(didTapSignOut), for: .touchUpInside)
        return button
    }()
    
    private lazy var boardManager: BLTNItemManager = {
        let item = BLTNPageItem(title: L10n.titleSignOut)
        item.actionButtonTitle = L10n.buttonSignOut
        item.alternativeButtonTitle = L10n.buttonCancel
        item.descriptionText = L10n.descriptionLabel
        
        item.actionHandler = { _ in
            self.didSignOut()
        }
        
        item.alternativeHandler = { _ in
            self.dismiss(animated: true)
        }
        item.appearance.actionButtonColor = .orange
//        item.appearance.alternativeButtonTitleColor = .green
        return BLTNItemManager(rootItem: item)
    }()
    
    //MARK: - Parent Delegate
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = hexStringToUIColor(hex: "370617")
        
        configureConstraints()
        observeData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        compositeDisposable = CompositeDisposable()
        compositeDisposable.disposed(by: disposeBag)
    }
    
    //MARK: - Functions
    private func configureConstraints() {
        view.addSubview(profileTableView)
        view.addSubview(signOutButton)
        
        let top = view.safeAreaLayoutGuide.snp.top
        let left = view.safeAreaLayoutGuide.snp.left
        let right = view.safeAreaLayoutGuide.snp.right
        let bottom = view.safeAreaLayoutGuide.snp.bottom
        
        profileTableView.snp.makeConstraints { make in
            make.top.equalTo(top).offset(10)
            make.left.equalTo(left).offset(20)
            make.right.equalTo(right).offset(-20)
            make.bottom.equalTo(signOutButton.snp.top).offset(-10)
        }
        
        signOutButton.snp.makeConstraints { make in
            make.left.equalTo(left).offset(20)
            make.right.equalTo(right).offset(-20)
            make.bottom.equalTo(bottom).offset(-10)
            make.height.equalTo(40)
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
                    }
                }
            }
        let _ = compositeDisposable.insert(profileSubscription)
    }
    
    @objc
    private func didTapSignOut() {
        boardManager.showBulletin(above: self, animated: true)
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
        cell.backgroundColor = hexStringToUIColor(hex: "6a040f")
        cell.layer.cornerRadius = 12
        cell.clipsToBounds = true
        cell.layer.opacity = 0.5
        cell.textLabel?.textColor = hexStringToUIColor(hex: "f8f9fa")
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        cell.textLabel?.text = profileVM.model[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60 
    }
}
