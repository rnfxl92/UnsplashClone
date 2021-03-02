//
//  Scene.swift
//  UnsplashClone
//
//  Created by 박성민 on 2021/02/12.
//

import UIKit

enum Scene {
    case photo(PhotoViewModel)
    case detail(PhotoViewModel, IndexPath, String?)
    case search
}

extension Scene {
    func instantiate(from storyboard: String = "Main", sceneCoordinator: SceneCoordinatorType) -> UIViewController {
      let storyboard = UIStoryboard(name: storyboard, bundle: nil)
      
      switch self {
      case .photo(let viewModel):
         guard var vc = storyboard.instantiateViewController(withIdentifier: "PhotoVC") as? PhotoViewController
         else {
            fatalError()
         }
         
        DispatchQueue.main.async {
            vc.bind(viewModel: viewModel)
        }
        vc.coordinator = sceneCoordinator
        return vc
      case .detail(let viewModel, let indexPath, let query):
        guard var vc = storyboard.instantiateViewController(withIdentifier: "DetailVC") as? DetailViewController
        else {
           fatalError()
        }
        DispatchQueue.main.async {
            vc.bind(viewModel: viewModel)
        }
        vc.coordinator = sceneCoordinator
        vc.defaultIndexPath = indexPath
        vc.query = query
        
        return vc
      case .search:
        guard let vc = storyboard.instantiateViewController(withIdentifier: "SearchVC") as? UITabBarController
        else {
           fatalError()
        }
        return vc
      }
   }
}
