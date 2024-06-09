//
//  Cell+Extension.swift
//  giphy
//
//  Created by najin on 4/10/24.
//

import UIKit
import RxSwift

protocol ReusableView {
    static var reuseIdentifier: String { get }
}

extension UITableViewCell: ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
