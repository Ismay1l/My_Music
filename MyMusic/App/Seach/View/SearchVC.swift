//
//  SearchVC.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 25.08.22.
//

import UIKit
import RxSwift
import CHTCollectionViewWaterfallLayout

class SearchVC: UIViewController {
    
    //MARK: - Variables
    private let searchVM = SearchVM()
    private var compositeBag = CompositeDisposable()
    private var disposeBag = DisposeBag()
    private var categories = [CategoryItem]()
    
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
        let layout = CHTCollectionViewWaterfallLayout()
        layout.itemRenderDirection = .leftToRight
        layout.columnCount = 2
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = hexStringToUIColor(hex: "370617")
        view.showsVerticalScrollIndicator = false
        
        view.register(SearchGenreCollectionViewCell.self, forCellWithReuseIdentifier: "\(SearchGenreCollectionViewCell.self)")
        
        view.delegate = self
        view.dataSource = self
        return view
    }()

    //MARK: - Parent Delegate
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = hexStringToUIColor(hex: "370617")
        
        setUpBackBarButton()
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
    
    private func setUpBackBarButton() {
        let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        item.tintColor = hexStringToUIColor(hex: "f8f9fa")
        self.navigationItem.backBarButtonItem = item
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
        addToDisposeBag(subscription: categoriesSubscription)
    }
    
    private func addToDisposeBag(subscription: Disposable) {
        let _ = compositeBag.insert(subscription)
    }
}

//MARK: - Extension SearchVC
extension SearchVC: UISearchResultsUpdating,
                    UICollectionViewDelegate,
                    UICollectionViewDataSource,
                    CHTCollectionViewDelegateWaterfallLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.size.width / 2,
               height: CGFloat.random(in: 150...250))
    }

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
        cell.layer.cornerRadius = 16
        cell.layer.masksToBounds = true
        let item = categories[indexPath.row]
        cell.configureCell(with: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let categoryVC = CategoryVC(category: categories[indexPath.row])
        categoryVC.title = categories.first?.name
        categoryVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(categoryVC, animated: true)
    }
}
