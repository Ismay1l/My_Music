//
//  CategoryVC.swift
//  MyMusic
//
//  Created by USER11 on 9/9/22.
//

import UIKit
import RxSwift

class CategoryVC: UIViewController {
    
    //MARK: - Variables
    var category: CategoryItem
    private let categoryVM = CategoryVM()
    private var compositeBag = CompositeDisposable()
    private var disposeBag = DisposeBag()
    private var playlist = [Item]()
    
    //MARK: - UI Elements
    private lazy var playlistCollectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { _, _ -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                                 heightDimension: .fractionalHeight(1)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(200)),
                subitem: item,
                count: 2
            )
            group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            return NSCollectionLayoutSection(group: group)
        }
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = hexStringToUIColor(hex: "370617")
        
        view.dataSource = self
        view.delegate = self
        view.register(CategoriesPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: "\(CategoriesPlaylistCollectionViewCell.self)")
        return view
    }()
    
    init(category: CategoryItem) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    //MARK: - Parent Delegate
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = hexStringToUIColor(hex: "370617")
        self.title = category.name
        
        configureConstraints()
        observeData()
        
        let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        item.tintColor = hexStringToUIColor(hex: "f8f9fa")
        self.navigationItem.backBarButtonItem = item
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        compositeBag = CompositeDisposable()
        compositeBag.disposed(by: disposeBag)
    }
    
    //MARK: - Functions
    private func configureConstraints() {
        view.addSubview(playlistCollectionView)
        
        let top = view.safeAreaLayoutGuide.snp.top
        let bottom = view.safeAreaLayoutGuide.snp.bottom
        let left = view.safeAreaLayoutGuide.snp.left
        let right = view.safeAreaLayoutGuide.snp.right
        
        playlistCollectionView.snp.makeConstraints { make in
            make.top.equalTo(top).offset(10)
            make.bottom.equalTo(bottom).offset(-10)
            make.left.equalTo(left).offset(20)
            make.right.equalTo(right).offset(-20)
        }
    }
    
    private func observeData() {
        let categoriesPlaylistSubscription = categoryVM.fetchCategoriesPlaylist(item: category)
            .subscribe { [weak self] result in
                guard let data = result.element else { return }
                switch data {
                case .showCategoriesPlaylist(let model):
                    DispatchQueue.main.async {
                        guard let items = model.playlists?.items else { return }
                        self?.playlist = items
                        self?.playlistCollectionView.reloadData()
                    }
                }
            }
        addToDisposeBag(subscription: categoriesPlaylistSubscription)
    }
    
    private func addToDisposeBag(subscription: Disposable) {
        let _ = compositeBag.insert(subscription)
    }
}

//MARK: - Extension CategoryVC
extension CategoryVC: UICollectionViewDelegate,
                      UICollectionViewDataSource,
                      UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        playlist.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(CategoriesPlaylistCollectionViewCell.self)", for: indexPath) as! CategoriesPlaylistCollectionViewCell
        let item = playlist[indexPath.row]
        cell.configureCell(with: item)
        cell.layer.cornerRadius = 12
        cell.layer.masksToBounds = true
        return cell
    }
}
