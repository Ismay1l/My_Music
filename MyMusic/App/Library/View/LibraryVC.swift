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
    private let switchView = LibrarySwitchView()
    private let  libraryVM = LibraryVM()
    private var  compositeBag = CompositeDisposable()
    private var disposeBag = DisposeBag()
    private let mainSchedulerInstance: ImmediateSchedulerType = MainScheduler.instance
    private var currentUserPlaylist = [Item]()
    
    //MARK: - UI Elements
    private lazy var segmentScrollView: UIScrollView = {
        let view = UIScrollView()
        view.isPagingEnabled = true
        view.delegate = self
        view.backgroundColor = hexStringToUIColor(hex: "370617")
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    //MARK: - Parent Delegate
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = hexStringToUIColor(hex: "370617")
        segmentScrollView.contentSize = CGSize(width: view.frame.size.width * 2, height: segmentScrollView.frame.size.height)
        switchView.delegate = self
        
        configureConstraints()
        addChildVC()
        observeData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        compositeBag = CompositeDisposable()
        compositeBag.disposed(by: disposeBag)
    }
    
    //MARK: - Functions
    private func configureConstraints() {
        view.addSubview(segmentScrollView)
        view.addSubview(switchView)
        
        let top = view.safeAreaLayoutGuide.snp.top
        let left = view.safeAreaLayoutGuide.snp.left
        let right = view.safeAreaLayoutGuide.snp.right
        let bottom = view.safeAreaLayoutGuide.snp.bottom
        
        switchView.snp.makeConstraints { make in
            make.left.equalTo(left)
            make.right.equalTo(right)
            make.top.equalTo(top)
            make.height.equalTo(40)
        }
        
        segmentScrollView.snp.makeConstraints { make in
            make.left.equalTo(left)
            make.right.equalTo(right)
            make.top.equalTo(switchView.snp.bottom)
            make.bottom.equalTo(bottom)
        }
    }
    
    private func addChildVC() {
        addChild(libraryPlaylistVC)
        segmentScrollView.addSubview(libraryPlaylistVC.view)
        
        libraryPlaylistVC.view.frame = CGRect(x: 0, y: 0, width: segmentScrollView.frame.size.width, height: segmentScrollView.frame.size.height)
        libraryPlaylistVC.didMove(toParent: self)
        
        addChild(libraryAlbumVC)
        segmentScrollView.addSubview(libraryAlbumVC.view)
        
        libraryAlbumVC.view.frame = CGRect(x: view.frame.size.width, y: 0, width: segmentScrollView.frame.size.width, height: segmentScrollView.frame.size.height)
        libraryAlbumVC .didMove(toParent: self)
    }
    
    private func observeData() {
        let currentUserPlaylistSubscription = libraryVM.fetchCurrentUserPlaylist()
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
            
        } else {
            
        }
    }
}

//MARK: - Extension LibraryVC
extension LibraryVC: UIScrollViewDelegate,
                     LibrarySwitchViewDelegate {
    func switchToPlaylistVC(_ view: LibrarySwitchView) {
        segmentScrollView.setContentOffset(.zero, animated: true)
    }
    
    func switchToAlbumVC(_ view: LibrarySwitchView) {
        segmentScrollView.setContentOffset(CGPoint(x: view.frame.size.width, y: 0), animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x >= (view.frame.size.width - 100) {
            switchView.updateIndicator(_for: .album)
        } else {
            switchView.updateIndicator(_for: .playlist)
        }
    }
}
