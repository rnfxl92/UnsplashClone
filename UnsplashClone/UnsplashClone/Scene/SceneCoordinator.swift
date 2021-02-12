//
//  SceneCoordinator.swift
//  UnsplashClone
//
//  Created by 박성민 on 2021/02/12.
//

import Foundation
import RxSwift
import RxCocoa

extension UIViewController {
    var sceneViewController: UIViewController {
        return self.children.first ?? self
    }
}

//class SceneCoordinator: SceneCoordinatorType {
//    private let bag = DisposeBag()
//    private var window: UIWindow
//    private var currentVC: UIViewController
//    
//    required init(window: UIWindow) {
//        self.window = window
//        currentVC = window.rootViewController!
//    }
//    
//    @discardableResult
//    func transition(to scene: Scene, using style: TranstionStyle, animated: Bool) -> Completable {
//        let subject = PublishSubject<Void>()
//    }
//    
//    func close(animated: Bool) -> Completable {
//        
//    }
//    
//}
