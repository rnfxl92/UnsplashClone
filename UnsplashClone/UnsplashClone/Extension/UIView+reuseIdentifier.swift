//
//  UIView+reuseIdentifier.swift
//  UnsplashClone
//
//  Created by 박성민 on 2021/02/21.
//

import UIKit

extension UIView {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
