//
//  SceneCoordinator.swift
//  UnsplashClone
//
//  Created by 박성민 on 2021/02/12.
//

import UIKit

extension UIViewController {
    var sceneViewController: UIViewController {
        return self.children.first ?? self
    }
}

class SceneCoordinator: SceneCoordinatorType {
    private var window: UIWindow
    private var currentVC: UIViewController
    
    required init(window: UIWindow) {
        self.window = window
        currentVC = window.rootViewController!
    }
    
    func transition(to scene: Scene, using style: TranstionStyle, animated: Bool) {
        let target = scene.instantiate()
        switch style {
        case .root:
           currentVC = target.sceneViewController
           window.rootViewController = target
        case .push:
           print(currentVC)
           guard let nav = currentVC.navigationController else {
              print("nav error")
              break
           }
           nav.pushViewController(target, animated: animated)
           currentVC = target.sceneViewController
        case .modal:
           currentVC.present(target, animated: animated)
           currentVC = target.sceneViewController
        }
        
    }
    
    func close(animated: Bool) {
        
    }
    
}
