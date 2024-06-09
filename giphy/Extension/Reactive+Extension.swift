//
//  Reactive+Extension.swift
//  giphy
//
//  Created by najin on 4/14/24.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UIScrollView {
    
    // ScrollView 스크롤 최하단 도달 이벤트
    func reachedBottom(from space: CGFloat = 0.0) -> ControlEvent<Void> {
        let source = contentOffset.map { contentOffset in
            let visibleHeight = self.base.frame.height - self.base.contentInset.top - self.base.contentInset.bottom // 화면 높이 (고정값)
            let y = contentOffset.y + self.base.contentInset.bottom // 스크롤 y축 위치값
            let threshold = self.base.contentSize.height - visibleHeight - space // 최하단 지점
            return y >= threshold // 최하단 지점으로 스크롤이 도달하면 event 방출
        }
        .distinctUntilChanged()
        .filter { $0 }
        .map { _ in () }
        
        return ControlEvent(events: source)
    }
}
