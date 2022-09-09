//
//  HomeVC.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 24.08.22.
//

import UIKit
import Shift
import RxSwift

class HomeVC: UIViewController {
    
    //MARK: - Variables
    private let homeVM = HomeVM()
    private var compositeDisposable = CompositeDisposable()
    private var disposeBag = DisposeBag()
    private let mainSchedulerInstance: ImmediateSchedulerType = MainScheduler.instance
    
    private var newReleases = [Album]()
    private var featuredPlaylists = [FeaturedPlaylistItem]()
    private var recommendations = [AudioTrack]()
    
    //MARK: - UI Elements
    private lazy var mainCollectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            return Self.createSectionLayout(section: sectionIndex)
        }
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = hexStringToUIColor(hex: "370617")
        view.showsVerticalScrollIndicator = false
        
        view.register(NewReleaseCollectionViewCell.self, forCellWithReuseIdentifier: "\(NewReleaseCollectionViewCell.self)")
        view.register(FeaturedPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: "\(FeaturedPlaylistCollectionViewCell.self)")
        view.register(RecommendedTrackCollectionViewCell.self, forCellWithReuseIdentifier: "\(RecommendedTrackCollectionViewCell.self)")
        view.register(MainCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(MainCollectionHeaderView.self)")
        
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.tintColor = .label
        return spinner
    }()
    
    //MARK: - Parent Delegate
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = hexStringToUIColor(hex: "370617")
        
        configureConstraints()
        observeData()
        
        let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        item.tintColor = hexStringToUIColor(hex: "f8f9fa")
        self.navigationItem.backBarButtonItem = item
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        compositeDisposable = CompositeDisposable()
        compositeDisposable.disposed(by: disposeBag)
    }
    
    //MARK: - Functions
    private func configureConstraints() {
        view.addSubview(mainCollectionView)
        view.addSubview(spinner)
        
        let top = view.safeAreaLayoutGuide.snp.top
        let left = view.safeAreaLayoutGuide.snp.left
        let right = view.safeAreaLayoutGuide.snp.right
        let bottom = view.safeAreaLayoutGuide.snp.bottom
        
        mainCollectionView.snp.makeConstraints { make in
            make.top.equalTo(top)
            make.left.equalTo(left)
            make.right.equalTo(right)
            make.bottom.equalTo(bottom).offset(-10)
        }
    }
    
    private static func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        let supplementaryViews = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(50)),
                elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            
        ]
        switch section {
        case 0:
            //Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 10, trailing: 5)
            
            //Vertical group in horizontal group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(390)),
                subitem: item,
                count: 2
            )
            
            //Horizontal group
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.92),
                    heightDimension: .absolute(390)),
                subitem: verticalGroup,
                count: 2)
            
            //Section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPagingCentered
            section.boundarySupplementaryItems = supplementaryViews
            return section
        case 1:
            //Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(180),
                    heightDimension: .absolute(240)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 4, bottom: 10, trailing: 4)
            
            //Group
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(180),
                    heightDimension: .absolute(240)),
                subitem: item,
                count: 1)
            
            //Section
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = supplementaryViews
            return section
        case 2:
            //Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 4, bottom: 2, trailing: 4)
            
            //Vertical group
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(70)),
                subitem: item,
                count: 1
            )
            
            //Section
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplementaryViews
            return section
        default:
            //Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
            
            //Vertical group in horizontal group
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(390)),
                subitem: item,
                count: 1
            )
            
            //Section
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplementaryViews
            return section
        }
    }
    
    private func observeData() {
        let newReleasesSubscription = homeVM.fetchBrowseNewReleasesData()
            .observe(on: mainSchedulerInstance)
            .subscribe { [weak self] received in
                DispatchQueue.main.async {
                    guard let data = received.element else { return }
                    switch data {
                    case .showNewReleases(let model):
                        guard let albums = model.albums?.items else { return }
                        self?.newReleases = albums
                        self?.mainCollectionView.reloadData()
                    }
                }
            }
        
        let featuredPlaylistsSubscription = homeVM.fetchFeaturedPlaylist()
            .observe(on: mainSchedulerInstance)
            .subscribe { [weak self] received in
                DispatchQueue.main.async {
                    guard let data = received.element else { return }
                    switch data {
                    case .showFeaturedPlaylists(let model):
                        guard let playlists = model.playlists?.items else { return }
                        self?.featuredPlaylists = playlists
                        self?.mainCollectionView.reloadData()
                    }
                }
            }
        
        let recommendationsSubscription = homeVM.fetchRecommendedGenres()
            .observe(on: mainSchedulerInstance)
            .subscribe { [weak self] received in
                DispatchQueue.main.async {
                    guard let data = received.element else { return }
                    switch data {
                    case .showRecommendations(let model):
                        guard let tracks = model.tracks else { return }
                        self?.recommendations = tracks
                        self?.mainCollectionView.reloadData()
                    }
                }
            }
        
        addToDisposeBag(subscription: newReleasesSubscription)
        addToDisposeBag(subscription: featuredPlaylistsSubscription)
        addToDisposeBag(subscription: recommendationsSubscription)
    }
    
    private func addToDisposeBag(subscription: Disposable) {
        let _ = compositeDisposable.insert(subscription)
    }
}

//MARK: Extension HomeVC
extension HomeVC: UICollectionViewDataSource,
                  UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return newReleases.count
        }
        else if section == 1 {
            return featuredPlaylists.count
        }
        else if section == 2 {
            return recommendations.count
        }
        else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(NewReleaseCollectionViewCell.self)", for: indexPath) as! NewReleaseCollectionViewCell
            let item = newReleases[indexPath.row]
            cell.configureCell(item: item)
            cell.layer.cornerRadius = 12
            cell.clipsToBounds = true
            return cell
        }
        else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(FeaturedPlaylistCollectionViewCell.self)", for: indexPath) as! FeaturedPlaylistCollectionViewCell
            let item = featuredPlaylists[indexPath.row]
            cell.configureCell(item: item)
            cell.layer.cornerRadius = 12
            cell.clipsToBounds = true
            return cell
        }
        else if indexPath.section == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(RecommendedTrackCollectionViewCell.self)", for: indexPath) as! RecommendedTrackCollectionViewCell
            cell.backgroundColor = hexStringToUIColor(hex: "370617")
            let item = recommendations[indexPath.row]
            cell.configureCell(item: item)
            cell.layer.cornerRadius = 12
            cell.clipsToBounds = true
            return cell
        }
        return UICollectionViewCell()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        collectionView.deselectItem(at: indexPath, animated: true)
        if indexPath.section == 0 {
            let album = newReleases[indexPath.row]
            let albumVC = AlbumVC(album: album)
            albumVC.title = album.name
            albumVC.navigationItem.largeTitleDisplayMode = .never
            let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
            item.tintColor = hexStringToUIColor(hex: "#231F20")
            albumVC.navigationItem.backBarButtonItem = item
            navigationController?.pushViewController(albumVC, animated: true)
        }
        else if indexPath.section == 1 {
            let playlist = featuredPlaylists[indexPath.row]
            let playlistVC = PlaylistVC(playlist: playlist)
            playlistVC.title = playlist.name
            playlistVC.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(playlistVC, animated: true)
        }
        else {
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(MainCollectionHeaderView.self)", for: indexPath) as! MainCollectionHeaderView
            if indexPath.section == 0 {
                header.configureHeader(_with: MainCollectionViewHeaderType.browse.collectionViewHeaders)
            } else if indexPath.section == 1 {
                header.configureHeader(_with: MainCollectionViewHeaderType.featuredPlaylists.collectionViewHeaders)
            } else {
                header.configureHeader(_with: MainCollectionViewHeaderType.recommendedTracks.collectionViewHeaders)
            }
            return header
        }
        return UICollectionReusableView()
    }
}
