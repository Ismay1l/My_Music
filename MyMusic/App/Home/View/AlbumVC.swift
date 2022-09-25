//
//  AlbumVC.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 04.09.22.
//

import UIKit
import RxSwift

class AlbumVC: UIViewController {
    
    //MARK: - Variables
    private var album: Album
    private let albumVM = AlbumVM()
    private var compositeBag = CompositeDisposable()
    private var disposeBag = DisposeBag()
    private var albumResponse = [Track]()
    private var albums = [AlbumDetailResponse]()
    
    //MARK: - UI Elements
    private lazy var mainCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.size.width - 40,
                                 height: 60)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = hexStringToUIColor(hex: "370617")
        view.showsVerticalScrollIndicator = false
        
        view.dataSource = self
        view.delegate = self
        view.register(BrowseAlbumsHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(BrowseAlbumsHeaderView.self)")
        view.register(BrowseAlbumsCollectionViewCell.self, forCellWithReuseIdentifier: "\(BrowseAlbumsCollectionViewCell.self)")
        
        return view
    }()
    
    init(album: Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    //MARK: - Parent Delegate
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = hexStringToUIColor(hex: "370617")
        
        configureConstraints()
        setupBarButton()
        observeData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        compositeBag = CompositeDisposable()
        compositeBag.disposed(by: disposeBag)
    }
    
    //MARK: - Functions
    private func observeData() {
        let albumDetailsSubscription = albumVM.fetchAlbumDetail(album: album)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] received in
                guard let data = received.element else { return }
                switch data {
                case .showAlbumDetails(let model):
                    DispatchQueue.main.async {
                        self?.albums = [model]
                        guard let tracks = model.tracks?.items else { return }
                        self?.albumResponse = tracks
                        self?.mainCollectionView.reloadData()
                    }
                }
            }
        let _ = compositeBag.insert(albumDetailsSubscription)
    }
    
    private func configureConstraints() {
        view.addSubview(mainCollectionView)
        
        mainCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(20)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-20)
        }
    }
    
    private func setupBarButton() {
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
        shareButton.tintColor = hexStringToUIColor(hex: "f8f9fa")
        navigationItem.rightBarButtonItem = shareButton
    }
    
    @objc
    private func didTapShare() {
        guard let url = URL(string: album.external_urls?.spotify ?? "NA") else { return }
        let vc = UIActivityViewController(activityItems: [url],
                                          applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}

//MARK: - Extension AlbumVC
extension AlbumVC: UICollectionViewDelegate,
                   UICollectionViewDataSource,
                   UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumResponse.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(BrowseAlbumsCollectionViewCell.self)", for: indexPath) as!  BrowseAlbumsCollectionViewCell
        let item = albumResponse[indexPath.row]
        cell.configureCell(item: item)
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        6
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(BrowseAlbumsHeaderView.self)", for: indexPath) as! BrowseAlbumsHeaderView
            header.configureHeader(item: album)
            header.delegate = self
            return header
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: mainCollectionView.frame.size.width, height: 380)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        var track = albumResponse[index]
        track.album = album
        PlaybackPresenter.shared.startPlaybackSong(from: self, track: track, tracks: albumResponse)
    }
}

extension AlbumVC: BrowseAlbumsHeaderViewDelegate {
    func didTapPlayButton(_ header: BrowseAlbumsHeaderView) {
        let tracksWithAlbumImage: [Track] = albumResponse.compactMap {
            var track = $0
            track.album = album
            return track
        }
        PlaybackPresenter.shared.startPlaybackSongs(from: self, tracks: tracksWithAlbumImage)
    }
}
