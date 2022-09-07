//
//  PlaylistVC.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 04.09.22.
//

import UIKit
import RxSwift

class PlaylistVC: UIViewController {

    //MARK: - Variables
    private let playlist: FeaturedPlaylistItem
    private let playlistVM = PlaylistVM()
    private var compositeBag = CompositeDisposable()
    private var disposeBag = DisposeBag()
    private var playlistResponse = [PlaylistTrackItem]()
    
    //MARK: - UI Elements
    private lazy var mainCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.size.width - 40,
                                 height: 60)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = hexStringToUIColor(hex: "370617")
        
        view.dataSource = self
        view.delegate = self
        view.register(PlaylistHeaderCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(PlaylistHeaderCollectionView.self)")
        view.register(PlaylistCollectionViewCell.self, forCellWithReuseIdentifier: "\(PlaylistCollectionViewCell.self)")
        
        return view
    }()
    
    init(playlist: FeaturedPlaylistItem) {
        self.playlist = playlist
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
        let playlistsSubscription = playlistVM.fetchPlaylists(playlist: playlist)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] response in
                guard let data = response.element else { return }
                switch data {
                case .showPlaylist(let model):
                    DispatchQueue.main.async {
                        guard let trackItem = model.tracks?.items else { return }
                        self?.playlistResponse = trackItem
                        self?.mainCollectionView.reloadData()
                    }
                }
            }
        let _  = compositeBag.insert(playlistsSubscription)
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
        navigationItem.rightBarButtonItem = shareButton
    }
    
    @objc
    private func didTapShare() {
        guard let url = URL(string: playlist.external_urls?["spotify"] ?? "NA") else { return }
        let vc = UIActivityViewController(activityItems: [url],
                                          applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}

//MARK: - Extension PlaylistVC
extension PlaylistVC: UICollectionViewDelegate,
                      UICollectionViewDataSource,
                      UICollectionViewDelegateFlowLayout,
                      PlaylistHeaderCollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        playlistResponse.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(PlaylistCollectionViewCell.self)", for: indexPath) as!  PlaylistCollectionViewCell
        cell.layer.cornerRadius = 5
        cell.clipsToBounds = true
        let item = playlistResponse[indexPath.row]
        cell.configureCell(item: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        6
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(PlaylistHeaderCollectionView.self)", for: indexPath) as! PlaylistHeaderCollectionView
            header.configureHeader(item: playlist)
            header.delegate = self
            return header
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: mainCollectionView.frame.size.width, height: 380)
    }
    
    func didTapPlayButton(_ header: PlaylistHeaderCollectionView) {
        print("Play Music Now")
    }
}
