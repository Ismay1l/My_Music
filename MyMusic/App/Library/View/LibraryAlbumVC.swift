//
//  LibraryAlbumVC.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 18.09.22.
//

import UIKit
import RxSwift

class LibraryAlbumVC: UIViewController {

    //MARK: - Variables
    private let alertView = AlertView()
    private var currentUserAlbum = [Album]()
    private let libraryAlbumVM = LibraryAlbumVM()
    private let mainSchedulerInstance: ImmediateSchedulerType = MainScheduler.instance
    private var compositeBag = CompositeDisposable()
    private var disposeBag = DisposeBag()
//    private let tabBar = CustomTabBarController()
    
    //MARK: - UI Elements
    private lazy var playlistTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.isHidden = true
        view.backgroundColor = hexStringToUIColor(hex: "370617")
        view.scrollsToTop = true
        view.showsVerticalScrollIndicator = false
        
        view.register(SearchResultAlbumCell.self, forCellReuseIdentifier: "\(SearchResultAlbumCell.self)")
        view.dataSource = self
        view.delegate = self
        return view
    }()

    //MARK: - Parent Delegate
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = hexStringToUIColor(hex: "370617")
        alertView.delegate = self
        alertView.isHidden = false
        
        configureConstraints()
        observeData()
        
        addDismissButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        compositeBag = CompositeDisposable()
        compositeBag.disposed(by: disposeBag)
    }
    
    //MARK: - Functions
    private func configureConstraints() {
        view.addSubview(alertView)
        view.addSubview(playlistTableView)
        
        alertView.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide.snp.center)
            make.height.width.equalTo(150)
        }
        
        playlistTableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    private func addDismissButton() {
    }
    
    private func observeData() {
//        let currentUserPlaylistSubscription = libraryPlaylistVM.fetchCurrentUserPlaylist()
//            .observe(on: mainSchedulerInstance)
//            .subscribe { [weak self] response in
//                guard let data = response.element else { return }
//                DispatchQueue.main.async {
//                    switch data {
//                    case .showUserPlaylist(let model):
//                        guard let items = model.items else { return }
//                        self?.currentUserPlaylist = items
//                        self?.updateUI()
//                    }
//                }
//            }
//        addToDisposeBag(subscription: currentUserPlaylistSubscription)
    }
    
    private func addToDisposeBag(subscription: Disposable) {
        let _ = compositeBag.insert(subscription)
    }
    
    private func updateUI() {
        if currentUserAlbum.isEmpty {
            alertView.isHidden = false
//            playlistTableView.isHidden = true
        } else {
            alertView.isHidden = true
//            playlistTableView.reloadData()
//            playlistTableView.isHidden = false
        }
    }
    
    @objc
    private func didTapCancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

//MARK: - Extension LibraryAlbumVC
extension LibraryAlbumVC: UITableViewDataSource,
                          UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currentUserAlbum.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(SearchResultAlbumCell.self)", for: indexPath) as! SearchResultAlbumCell
        let model = currentUserAlbum[indexPath.row]
        cell.configure(_with: SearchResultAlbumTableViewModel(title: model.name, subtitle: model.artists?.first?.name, imageURL: URL(string: model.images?.first?.url ?? "")))
        cell.backgroundColor = hexStringToUIColor(hex: "370617")
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = currentUserAlbum[indexPath.row]
        let albumVC = AlbumVC(album: model)
        navigationController?.pushViewController(albumVC, animated: true)
    }
}

extension LibraryAlbumVC: AlertViewDelegate {
    func alertViewButtonTapped(_ view: AlertView) {
        tabBarController?.selectedIndex = 0
//        tabBar.selectedIndex = 0
    }
}
