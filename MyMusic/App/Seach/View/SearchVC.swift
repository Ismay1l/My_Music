//
//  SearchVC.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 25.08.22.
//

import UIKit
import RxSwift

class SearchVC: UIViewController {
    
    //MARK: - Variables
    private let searchVM = SearchVM()
    private var compositeBag = CompositeDisposable()
    private var disposeBag = DisposeBag()
    private var categories = [CategoryItems]()
    
    //MARK: - UI Elements
    private var searchController: UISearchController = {
        let searchResultVC = SearchResultVC()
        let searchController = UISearchController(searchResultsController: searchResultVC)
        searchController.searchBar.placeholder = "Search songs, artists, albums"
        searchController.searchBar.searchBarStyle = .minimal
        searchController.definesPresentationContext = true
        return searchController
    }()
    
    private lazy var mainCollectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { _, _ in
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 4, bottom: 3, trailing: 4)
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(120)), subitem: item, count: 2)
            group.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3)
            return NSCollectionLayoutSection(group: group)
        }
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = hexStringToUIColor(hex: "370617")
        
        view.register(SearchGenreCollectionViewCell.self, forCellWithReuseIdentifier: "\(SearchGenreCollectionViewCell.self)")
        
        view.delegate = self
        view.dataSource = self
        return view
    }()

    //MARK: - Parent Delegate
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = hexStringToUIColor(hex: "370617")
        
        setUpSearchView()
        configureConstraints()
        observeData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        compositeBag = CompositeDisposable()
        compositeBag.disposed(by: disposeBag)
    }
    
    //MARK: - Functions
    private func setUpSearchView() {
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
    
    private func configureConstraints() {
        view.addSubview(mainCollectionView)
        
        mainCollectionView.snp.makeConstraints { make in
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(10)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-10)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
    }
    
    private func observeData() {
        let categoriesSubscription = searchVM.fetchCategories()
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] received in
                guard let data = received.element else { return }
                switch data {
                case .showCategories(let model):
                    DispatchQueue.main.async {
                        guard let items = model.categories?.items else { return }
                        self?.categories = items
                        self?.mainCollectionView.reloadData()
                    }
                }
            }
        let _ = compositeBag.insert(categoriesSubscription)
    }
}

//MARK: - Extension SearchVC
extension SearchVC: UISearchResultsUpdating,
                    UICollectionViewDelegate,
                    UICollectionViewDataSource,
                    UICollectionViewDelegateFlowLayout {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let resultController = searchController.searchResultsController as? SearchResultVC,
              let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        print("Query: \(query)")
        //Call Search Call
        //resultController.update(with:_)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(SearchGenreCollectionViewCell.self)", for: indexPath) as! SearchGenreCollectionViewCell
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        let item = categories[indexPath.row]
        cell.configureCell(with: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
}
