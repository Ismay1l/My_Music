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
        
        configureConstraints()
        observeData()
        addDismissButton()
        setUpBarbUtton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        compositeBag = CompositeDisposable()
        compositeBag.disposed(by: disposeBag)
    }
    
    //MARK: - Functions
    private func configureConstraints() {
        view.addSubview(playlistTableView)
        
        playlistTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    private func setUpBarbUtton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton(_:)))
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
            playlistTableView.isHidden = true
        } else {
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
    
    private func showAlert() {
        let alert = UIAlertController(title: L10n.newPlaylistLabel,
                                      message: L10n.newPlaylistMessage,
                                      preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = L10n.newPlaylistPlaceholder
        }
        
        alert.addAction(UIAlertAction(title: L10n.buttonCancel, style: .cancel))
        alert.addAction(UIAlertAction(title: L10n.buttonOkay, style: .default, handler: { _ in
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
    
    @objc
    private func didTapAddButton(_ sender: UIBarButtonItem) {
        showAlert()
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
        cell.backgroundColor = Asset.Colors.black.color
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
