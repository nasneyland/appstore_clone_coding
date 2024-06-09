//
//  GifLayout.swift
//  giphy
//
//  Created by najin on 4/10/24.
//

import UIKit

protocol GifLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForIndexPath indexPath: IndexPath , cellWidth : CGFloat ) -> CGFloat
}

class GifLayout: UICollectionViewLayout {
    
    //MARK: - Properties
    
    weak var delegate: GifLayoutDelegate?
    
    var numberOfColumns = 1
    
    private let cellPadding: CGFloat = 6
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    //MARK: - Lifecycle
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        guard let collectionView = collectionView else { return }
        
        cache.removeAll()
        contentHeight = 0.0
        
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
      
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let calculatedHeight = delegate?.collectionView( collectionView, heightForIndexPath: indexPath , cellWidth: columnWidth) ?? 0
            let height = cellPadding * 2 + calculatedHeight
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height) // cell 위치 및 크기 지정
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)

            // 셀 캐싱 처리
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height

            // 높이가 달라 각 열의 총합 높이가 비대칭이 되는 현상 -> 셀을 쌓을 때 높이가 작은쪽으로 쌓도록
//            column = column < (numberOfColumns - 1) ? (column + 1) : 0
            column = yOffset.firstIndex(of: yOffset.min()!) ?? 0
        }
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
  
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
    
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
  
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
    override open func invalidateLayout() {
        super.invalidateLayout()
        self.cache.removeAll()
    }
}
