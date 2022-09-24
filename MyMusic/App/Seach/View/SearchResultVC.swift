//
//  SearchResultVC.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 25.08.22.
//

import UIKit

class SearchResultVC: UIViewController {
    
    //MARK: - Variables
    private var sections: [SearchSection] = []
    weak var delegate: SearchResultVCDelegate?
    
    //MARK: - UI Elements
    private lazy var resultTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.isHidden = true
        view.backgroundColor = hexStringToUIColor(hex: "370617")
        view.scrollsToTop = true
        view.showsVerticalScrollIndicator = false
        
        view.register(SearchResultArtistCell.self, forCellReuseIdentifier: "\(SearchResultArtistCell.self)")
        view.register(SearchResultAlbumCell.self, forCellReuseIdentifier: "\(SearchResultAlbumCell.self)")
        
        view.dataSource = self
        view.delegate = self
        return view
    }()

    //MARK: - Parent Delegate
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = hexStringToUIColor(hex: "370617")
        
        configureConstraints()
    }
    
    //MARK: - Functions
    func update(with result: [SearchResult]) {
        let artists = result.filter { result in
            switch result {
            case .artist:
                return true
            default:
                return false
            }
        }
        
        let albums = result.filter { result in
            switch result {
            case .album:
                return true
            default:
                return false
            }
        }
        
        let tracks = result.filter { result in
            switch result {
            case .track:
                return true
            default:
                return false
            }
        }
        
        let playlists = result.filter { result in
            switch result {
            case .playlist:
                return true
            default:
                return false
            }
        }
        sections = [
            SearchSection(title: "Songs", results: tracks),
            SearchSection(title: "Artists", results: artists),
            SearchSection(title: "Albums", results: albums),
            SearchSection(title: "Playlists", results: playlists)
        ]
        resultTableView.reloadData()
        resultTableView.isHidden = result.isEmpty
    }
    
    private func configureConstraints() {
        view.addSubview(resultTableView)
        
        resultTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(5)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-5)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(10)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-10)
        }
    }
}

//MARK: - Extension SearchResultVC
extension SearchResultVC: UITableViewDataSource,
                          UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].results?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = sections[indexPath.section].results?[indexPath.row]
        
        switch result {
        case .artist(let artist):
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(SearchResultArtistCell.self)", for: indexPath) as! SearchResultArtistCell
            let model = SearchResultArtistTableViewModel(title: artist.name,
                                                        imageURL: URL(string: artist.images?.first?.url ?? ""))
            cell.configure(_with: model)
            cell.backgroundColor = hexStringToUIColor(hex: "370617")
            cell.selectionStyle = .none
            return cell
        case .album(let album):
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(SearchResultAlbumCell.self)", for: indexPath) as! SearchResultAlbumCell
            let model = SearchResultAlbumTableViewModel(title: album.name, subtitle: album.artists?.first?.name, imageURL: URL(string: album.images?.first?.url ?? ""))
            cell.configure(_with: model)
            cell.backgroundColor = hexStringToUIColor(hex: "370617")
            cell.selectionStyle = .none
            return cell
        case .track(let track):
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(SearchResultAlbumCell.self)", for: indexPath) as! SearchResultAlbumCell
            let model = SearchResultAlbumTableViewModel(title: track.name, subtitle: track.artists?.first?.name, imageURL: URL(string: track.album?.images?.first?.url ?? ""))
            cell.configure(_with: model)
            cell.backgroundColor = hexStringToUIColor(hex: "370617")
            cell.selectionStyle = .none
            return cell
        case .playlist(let playlist):
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(SearchResultAlbumCell.self)", for: indexPath) as! SearchResultAlbumCell
            let model = SearchResultAlbumTableViewModel(title: playlist.name, subtitle: playlist.owner?.display_name, imageURL: URL(string: playlist.images?.first?.url ?? ""))
            cell.configure(_with: model)
            cell.backgroundColor = hexStringToUIColor(hex: "370617")
            cell.selectionStyle = .none
            return cell
        case .none:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let result = sections[indexPath.section].results?[indexPath.row] else { return }
        delegate?.didSelectOption(result)
    }
}
 
