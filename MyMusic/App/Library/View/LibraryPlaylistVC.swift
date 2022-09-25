//
//  LibraryPlaylistVC.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 18.09.22.
//

import UIKit
import RxSwift

class LibraryPlaylistVC: UIViewController {
    
    //MARK: - Variables
    private let alertView = AlertView()
    private var currentUserPlaylist = [Item]()
    private let libraryPlaylistVM = LibraryPlaylistVM()
    private let mainSchedulerInstance: ImmediateSchedulerType = MainScheduler.instance
    private var compositeBag = CompositeDisposable()
    private var disposeBag = DisposeBag()
    public var selectionHandler: ((Item) -> Void)?
    
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
        if selectionHandler != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancelButton(_:)))
        }
    }
    
    private func observeData() {
        let currentUserPlaylistSubscription = libraryPlaylistVM.fetchCurrentUserPlaylist()
            .observe(on: mainSchedulerInstance)
            .subscribe { [weak self] response in
                guard let data = response.element else { return }
                DispatchQueue.main.async {
                    switch data {
                    case .showUserPlaylist(let model):
                        guard let items = model.items else { return }
                        self?.currentUserPlaylist = items
                        self?.updateUI()
                    }
                }
            }
        addToDisposeBag(subscription: currentUserPlaylistSubscription)
    }
    
    private func addToDisposeBag(subscription: Disposable) {
        let _ = compositeBag.insert(subscription)
    }
    
    private func updateUI() {
        if currentUserPlaylist.isEmpty {
            alertView.isHidden = false
            playlistTableView.isHidden = true
        } else {
            alertView.isHidden = true
            playlistTableView.reloadData()
            playlistTableView.isHidden = false
        }
    }
    
    private func createPlaylist(_ name: String) {
        libraryPlaylistVM.createPlaylist(name) {[weak self] success in
            if success {
                print("Playlist created")
                self?.observeData()
            }
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "New Playlist",
                                      message: "Enter playlist name",
                                      preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Playlist...."
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            guard let textField = alert.textFields?.first,
                  let text = textField.text,
                  !text.trimmingCharacters(in: .whitespaces).isEmpty else {
                      return
                  }
            self.createPlaylist(text)
        }))
        
        present(alert, animated: true)
    }
    
    @objc
    private func didTapCancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

//MARK: - Extension LibraryPlaylistVC
extension LibraryPlaylistVC: UITableViewDataSource,
                             UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currentUserPlaylist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(SearchResultAlbumCell.self)", for: indexPath) as! SearchResultAlbumCell
        let model = currentUserPlaylist[indexPath.row]
        cell.configure(_with: SearchResultAlbumTableViewModel(title: model.name, subtitle: model.owner?.display_name, imageURL: URL(string: model.images?.first?.url ?? "")))
        cell.backgroundColor = hexStringToUIColor(hex: "370617")
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = currentUserPlaylist[indexPath.row]
        
        guard selectionHandler == nil else {
            selectionHandler?(model)
            dismiss(animated: true)
            return
        }
        let playlistVC = PlaylistVC(playlist: model)
        playlistVC.isOwner = true
        navigationController?.pushViewController(playlistVC, animated: true)
    }
}

extension LibraryPlaylistVC: AlertViewDelegate {
    func alertViewButtonTapped(_ view: AlertView) {
        showAlert()
    }
}
