//
//  GifView.swift
//  giphy
//
//  Created by najin on 4/10/24.
//

import UIKit
import SnapKit

class GifView: UIView, UICollectionViewDelegateFlowLayout {
    
    //MARK: - Properties
    
    lazy var layout = GifLayout()
    
    lazy var gifCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.keyboardDismissMode = .onDrag
        collectionView.register(GifCollectionViewCell.self, forCellWithReuseIdentifier: GifCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
    let errorView = UIView()
    
    private lazy var errorEmoji: UILabel = {
        let label = UILabel()
        label.text = "😵"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30)
        return label
    }()
    
    private lazy var errorText: UILabel = {
        let label = UILabel()
        label.text = "네트워크 통신이 불안정해요.\n네트워크 연결 후 재시도 해주세요."
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    lazy var reloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("재시도 >", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configures
    
    private func configureUI() {
        gifCollectionView.isHidden = true
        errorView.isHidden = true
        
        addSubview(gifCollectionView)
        gifCollectionView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(10.0)
        }
        
        // Error View
        
        addSubview(errorView)
        errorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        errorView.addSubview(errorText)
        errorText.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        errorView.addSubview(errorEmoji)
        errorEmoji.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(errorText.snp.top).offset(-10)
        }
        
        errorView.addSubview(reloadButton)
        reloadButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(errorText.snp.bottom).offset(20)
            make.width.equalTo(250)
            make.height.equalTo(50)
        }
    }
    
    // MARK: - Helper
    
    func showErrorView(_ show: Bool = true) {
        gifCollectionView.isHidden = show
        errorView.isHidden = !show
    }
}
