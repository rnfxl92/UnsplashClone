//
//  Scene.swift
//  UnsplashClone
//
//  Created by 박성민 on 2021/02/12.
//

import UIKit

enum Scene {
    case main(PhotoViewModel)
}

extension Scene {
   func instantiate(from storyboard: String = "Main") -> UIViewController {
      let storyboard = UIStoryboard(name: storyboard, bundle: nil)
      
      switch self {
      case .main(let viewModel):
         guard var vc = storyboard.instantiateViewController(withIdentifier: "PhotoVC") as? PhotoViewController else {
            fatalError()
         }
         
        DispatchQueue.main.async {
            vc.bind(viewModel: viewModel)
        }
        
         return vc
      }
   }
}
