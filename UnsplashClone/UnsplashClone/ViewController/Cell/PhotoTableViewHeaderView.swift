//
//  PhotoTableViewHeaderView.swift
//  UnsplashClone
//
//  Created by 박성민 on 2021/02/19.
//

import UIKit

class PhotoTableViewHeaderView: UIView {

    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    
    func configureHeaderImage(image: UIImage?) {
        DispatchQueue.main.async { [unowned self] in
            self.headerImageView.image = image
        }
    }
}
