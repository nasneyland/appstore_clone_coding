//
//  SearchViewController.swift
//  giphy
//
//  Created by najin on 4/10/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxViewController

class SearchViewController: UIViewController {
    
    //MARK: - Properties
    
    var coordinator: SearchCoordinator?
    
    private let viewModel: SearchViewModel
    private let selfView = GifView()
    
    private lazy var searchController: UISearchController = {
        var searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "검색어를 입력하세요"
        searchController.searchBar.setShowsCancelButton(false, animated: false)
        return searchController
    }()
    
    var dataSource = BehaviorRelay<[GifModel]>(value: [])
    
    let disposeBag = DisposeBag()

    //MARK: - Lifecycle
    
    init(viewModel: SearchViewModel) {
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
        navigationController?.isNavigationBarHidden = false
        navigationItem.searchController = searchController
    }
    
    private func configureUI() {
        selfView.layout.numberOfColumns = 3
        selfView.layout.delegate = self
        
        view.backgroundColor = .white
        
        view.addSubview(selfView)
        selfView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func binding() {
        
        //MARK: Binding ViewModel
        
        // 서치바 키워드 검색 이벤트
        let editKeyword = searchController.searchBar.searchTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .do(onNext: { _ in
                self.selfView.gifCollectionView.contentSize = CGSize(width: self.selfView.gifCollectionView.contentSize.width, height: 0)
                self.dataSource.accept([])
            })
            .asObservable()
        
        // 서치바 검색 버튼 클릭 이벤트
        let tapSearch = searchController.searchBar.rx.searchButtonClicked
            .map { (self.searchController.searchBar.searchTextField.text ?? "") }
            .asObservable()
        
        // 스크롤 최하단 도달 시 페이징 처리 (데이터 추가 로드)
        let reachedScrollBottom = selfView.gifCollectionView.rx.reachedBottom(from: 500.0)
            .map { (self.searchController.searchBar.searchTextField.text ?? "", self.dataSource.value.count) }
            .asObservable()
        
        // 네트워크 에러시 재시도 버튼 클릭
        let reloadData = selfView.reloadButton.rx.tap
            .map { (self.searchController.searchBar.searchTextField.text ?? "", self.dataSource.value.count) }
            .asObservable()
        
        let output = viewModel.transform(input: .init(editKeyword: editKeyword, 
                                                      tapSearch:tapSearch,
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
        
//        searchController.searchBar.searchTextField.rx.controlEvent([.editingChanged])
//            .bind {
//                if self.searchController.searchBar.text == "" {
//                    self.selfView.gifCollectionView.contentSize = CGSize(width: self.selfView.gifCollectionView.contentSize.width, height: 0)
//                    self.dataSource.accept([])
//                }
//        }
//        .disposed(by: disposeBag)
        
        dataSource
            .bind(to: selfView.gifCollectionView.rx.items(cellIdentifier: GifCollectionViewCell.reuseIdentifier, cellType: GifCollectionViewCell.self)) {
                (row, element, cell) in
                print(row)
                cell.gifView.gifImageWithURL(element.url)
            }.disposed(by: disposeBag)
    }
}

//MARK: - Extension

extension SearchViewController: GifLayoutDelegate {
    // GIF 셀 높이 비율에 맞게 조절
    func collectionView(_ collectionView: UICollectionView, heightForIndexPath indexPath: IndexPath, cellWidth: CGFloat) -> CGFloat {
        let item = dataSource.value[indexPath.row]
        let scaleFactor = cellWidth / item.width
        return item.height * scaleFactor
    }
}
