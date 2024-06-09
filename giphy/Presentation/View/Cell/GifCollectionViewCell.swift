//
//  GifCollectionViewCell.swift
//  giphy
//
//  Created by najin on 4/10/24.
//

import UIKit

class GifCollectionViewCell: UICollectionViewCell {
    
    lazy var gifView: UrlImageView = {
        var view = UrlImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        view.backgroundColor = .systemGray6
//        view.image = UIImage(named: "placeholder")
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.gifView)
        self.gifView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
//        gifView.image = UIImage(named: "placeholder")
        gifView.cancleLoadingImage()
    }
}
