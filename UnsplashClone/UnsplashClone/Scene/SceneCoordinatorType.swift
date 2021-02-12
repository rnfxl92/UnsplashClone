//
//  SceneCoordinatorType.swift
//  UnsplashClone
//
//  Created by 박성민 on 2021/02/12.
//

import Foundation
import RxSwift

protocol SceneCoordinatorType {
    @discardableResult
    func transition(to scene: Scene, using style: TranstionStyle, animated: Bool) -> Completable
    
    @discardableResult
    func close(animated: Bool) -> Completable
}
