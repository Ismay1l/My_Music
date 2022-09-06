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
    private let album: Album
    private let albumVM = AlbumVM()
    private var compositeBag = CompositeDisposable()
    private var disposeBag = DisposeBag()
    
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
            .subscribe { received in
                guard let data = received.element else { return }
                switch data {
                case .showAlbumDetails(let model):
                    print("Album Detail: \(model.name ?? "NA")")
                    print("Album Detail: \(model.release_date ?? "NA")")
                }
            }
        let _ = compositeBag.insert(albumDetailsSubscription)
    }
}
