//
//  HomeViewController.swift
//  giphy
//
//  Created by najin on 4/10/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxViewController

class HomeViewController: UIViewController {
    
    //MARK: - Properties
    
    var coordinator: HomeCoordinator?
    
    private let viewModel: HomeViewModel
    private let selfView = GifView()
    
    var dataSource = BehaviorRelay<[GifModel]>(value: [])
    
    let disposeBag = DisposeBag()

    //MARK: - Lifecycle
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNav()
        configureUI()
        binding()
    }
    
    //MARK: - Configures
    
    private func configureNav() {
        navigationController?.isNavigationBarHidden = true
    }
    
    private func configureUI() {
        selfView.layout.numberOfColumns = 2
        selfView.layout.delegate = self
        
        view.backgroundColor = .white
        
        view.addSubview(selfView)
        selfView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func binding() {
        
        //MARK: Binding ViewModel
        
        // 최초 진입시 데이터 로드
        let fetching = self.rx.viewWillAppear.take(1).asObservable()
        
        // 스크롤 최하단 도달 시 페이징 처리 (데이터 추가 로드)
        let reachedScrollBottom = selfView.gifCollectionView.rx.reachedBottom(from: 1000.0)
            .skip(1)
            .map { self.dataSource.value.count }
            .asObservable()
        
        // 네트워크 에러시 재시도 버튼 클릭
        let reloadData = selfView.reloadButton.rx.tap
            .map { self.dataSource.value.count }
            .asObservable()
        
        let output = viewModel.transform(input: .init(fetching: fetching, 
                                                      reachedScrollBottom: reachedScrollBottom,
                                                      reloadData: reloadData))
        
        output.resultList
            .do(onNext: { _ in self.selfView.showErrorView(false) })
            .map { self.dataSource.value + $0 }
            .bind(to: dataSource)
            .disposed(by: disposeBag)
        
        output.isError
            .do(onNext: { self.selfView.showErrorView(true) })
            .bind { self.selfView.showErrorView() }
            .disposed(by: disposeBag)
        
        //MARK: Binding View
        
        dataSource
            .bind(to: selfView.gifCollectionView.rx.items(cellIdentifier: GifCollectionViewCell.reuseIdentifier, cellType: GifCollectionViewCell.self)) {
                (row, element, cell) in
                cell.gifView.gifImageWithURL(element.url)
            }.disposed(by: disposeBag)
    }
}

//MARK: - Extension

extension HomeViewController: GifLayoutDelegate {
    // GIF 셀 높이 비율에 맞게 조절
    func collectionView(_ collectionView: UICollectionView, heightForIndexPath indexPath: IndexPath, cellWidth: CGFloat) -> CGFloat {
        let item = dataSource.value[indexPath.row]
        let scaleFactor = cellWidth / item.width
        return item.height * scaleFactor
    }
}
