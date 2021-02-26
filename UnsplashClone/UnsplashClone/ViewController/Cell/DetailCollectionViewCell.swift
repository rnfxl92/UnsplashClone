//
//  DetailCollectionViewCell.swift
//  UnsplashClone
//
//  Created by 박성민 on 2021/02/26.
//

import UIKit

class DetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoImageViewCenterYConstraint: NSLayoutConstraint!
    
    private var imageHeight: CGFloat = .zero
    
    func configureImage(image: UIImage?) {
        photoImageView.image = image
        guard let image = image else { return }
        
        imageHeight = image.size.height
    }
    
    func animate(startY: CGFloat) {
        let differ = startY - (frame.size.height - (imageHeight / 2)) / 2
        photoImageViewCenterYConstraint.constant = differ

        guard abs(differ) > 15 else { return }

        layoutIfNeeded()

        UIView.animate(
            withDuration: 0.5,
            delay: .zero,
            usingSpringWithDamping: 0.85,
            initialSpringVelocity: 0.5,
            options: .curveEaseIn) { [weak self] in
            
            self?.photoImageViewCenterYConstraint.constant = .zero
            self?.layoutIfNeeded()
       }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
        imageHeight = .zero
        photoImageViewCenterYConstraint.constant = .zero
    }
    
}

extension DetailCollectionViewCell {
    
    enum Identifier {
        static let reusableCell: String = "DetailCell"
    }
    
    enum Name {
        static let typeName: String = "DetailCollectionViewCell"
    }
}
