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
    private var currentUserAlbum = [SavedAlbumResponseItem]()
    private let libraryAlbumVM = LibraryAlbumVM()
    private let mainSchedulerInstance: ImmediateSchedulerType = MainScheduler.instance
    private var compositeBag = CompositeDisposable()
    private var disposeBag = DisposeBag()
    private var observer: NSObjectProtocol?
    
    //MARK: - UI Elements
    private lazy var albumTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.isHidden = true
        view.backgroundColor = Asset.Colors.black.color
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
        view.backgroundColor = Asset.Colors.black.color
        alertView.delegate = self
        
        configureConstraints()
        observeData()
        notificationCenterHandler()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        compositeBag = CompositeDisposable()
        compositeBag.disposed(by: disposeBag)
    }
    
    //MARK: - Functions
    private func configureConstraints() {
        view.addSubview(alertView)
        view.addSubview(albumTableView)
        
        alertView.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide.snp.center)
            make.height.width.equalTo(150)
        }
        
        albumTableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    private func notificationCenterHandler() {
        observer = NotificationCenter.default.addObserver(forName: .savedAlbumNotification,
                                                          object: nil,
                                                          queue: .main,
                                                          using: {[weak self] _ in
            self?.observeData()
        })
    }
    
    private func observeData() {
        let savedAlbumsSubscription = libraryAlbumVM.fetchSavedAlbums()
            .observe(on: mainSchedulerInstance)
            .subscribe {[weak self] response in
                guard let data = response.element else { return }
                DispatchQueue.main.async {
                    switch data {
                    case .showSavedAlbum(let model):
                        guard let albums = model.items else { return }
                        self?.currentUserAlbum = albums
                        self?.updateUI()
                    }
                }
            }
        addToDisposeBag(savedAlbumsSubscription)
    }
    
    private func addToDisposeBag(_ subscription: Disposable) {
        let _ = compositeBag.insert(subscription)
    }
    
    private func updateUI() {
        if currentUserAlbum.isEmpty {
            alertView.isHidden = false
            albumTableView.isHidden = true
        } else {
            alertView.isHidden = true
            albumTableView.reloadData()
            albumTableView.isHidden = false
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
        cell.configure(_with: SearchResultAlbumTableViewModel(title: model.album?.name, subtitle: model.album?.artists?.first?.name, imageURL: URL(string: model.album?.images?.first?.url ?? "")))
        cell.backgroundColor = Asset.Colors.lightGray.color
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = currentUserAlbum[indexPath.row]
        guard let album = model.album else { return }
        let albumVC = AlbumVC(album: Album(artists: album.artists, available_markets: album.available_markets, external_urls: album.external_urls, id: album.id, name: album.name, release_date: album.release_date, total_tracks: album.total_tracks))
        navigationController?.pushViewController(albumVC, animated: true)
    }
}

extension LibraryAlbumVC: AlertViewDelegate {
    func alertViewButtonTapped(_ view: AlertView) {
        tabBarController?.selectedIndex = 0
//        tabBar.selectedIndex = 0
    }
}
