//
//  LibraryVC.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 25.08.22.
//

import UIKit
import RxSwift

class LibraryVC: UIViewController {
    
    //MARK: - Variables
    private let libraryPlaylistVC = LibraryPlaylistVC()
    private let libraryAlbumVC = LibraryAlbumVC()
    private let libraryVM = LibraryVM()
    
    //MARK: - UI Elements
    
    private lazy var optionTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = Asset.Colors.black.color
        view.scrollsToTop = true
        view.showsVerticalScrollIndicator = false
        
        view.register(OptionTableViewCell.self, forCellReuseIdentifier: "\(OptionTableViewCell.self)")
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    //MARK: - Parent Delegate
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.Colors.black.color
        
        setUpTableView()
        configureConstraints()
    }
    
    //MARK: - Functions
    private func configureConstraints() {
        view.addSubview(optionTableView)
        
        let top = view.safeAreaLayoutGuide.snp.top
        let left = view.safeAreaLayoutGuide.snp.left
        let right = view.safeAreaLayoutGuide.snp.right
        let bottom = view.safeAreaLayoutGuide.snp.bottom
        
        optionTableView.snp.makeConstraints { make in
            make.left.equalTo(left).offset(20)
            make.right.equalTo(right).offset(-20)
            make.top.equalTo(top).offset(10)
            make.bottom.equalTo(bottom).offset(-10)
        }
    }
    
    private func setUpTableView() {
        libraryVM.model.append(
            Option(title: L10n.playlistTitle, icon: "music.note.list", handler: {[weak self] in
                DispatchQueue.main.async {
                    guard let vc = self?.libraryPlaylistVC else { return }
                    self?.pushVC(vc, title: L10n.playlistTitle)
                }
            }))
        libraryVM.model.append(
            Option(title: L10n.albumTitle, icon: "square.stack",  handler: {[weak self] in
                DispatchQueue.main.async {
                    guard let vc = self?.libraryAlbumVC else { return }
                    self?.pushVC(vc, title: L10n.albumTitle)
                }
            }))
        libraryVM.model.append(
            Option(title: L10n.artistsTitle, icon: "music.mic", handler: {
               print("Artists selected")
            }))
        libraryVM.model.append(
            Option(title: L10n.madeForYouTitle, icon: "person.crop.square", handler: {
               print("Made For You selected")
            }))
        libraryVM.model.append(
            Option(title: L10n.songsTitle, icon: "music.note", handler: {
               print("Songs selected")
            }))
        libraryVM.model.append(
            Option(title: L10n.genresTitle, icon: "guitars", handler: {
               print("Genres selected")
            }))
        libraryVM.model.append(
            Option(title: L10n.composersTitle, icon: "person.2.crop.square.stack", handler: {
               print("Composers selected")
            }))
        libraryVM.model.append(
            Option(title: L10n.downloadedTitle, icon: "arrow.down.circle", handler: {
               print("Downloaded selected")
            }))
    }
    
    private func pushVC(_ viewController: UIViewController, title: String) {
        viewController.title = title
        viewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension LibraryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        libraryVM.model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(OptionTableViewCell.self)", for: indexPath) as! OptionTableViewCell
        let model = libraryVM.model[indexPath.row]
        cell.setUpCell(model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = libraryVM.model[indexPath.row]
        model.handler()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
}
