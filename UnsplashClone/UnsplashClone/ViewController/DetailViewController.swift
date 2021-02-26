//
//  DetailViewController.swift
//  UnsplashClone
//
//  Created by 박성민 on 2021/02/26.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var navigationTitleItem: UINavigationItem!
    @IBOutlet weak var detailCollectionView: UICollectionView!
    
    weak var coordinator: SceneCoordinatorType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
    func configureCollectionView() {
        detailCollectionView.delegate = self
        detailCollectionView.dataSource = self
    }

}

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: view.frame.width, height: view.frame.height)
    }
}

extension DetailViewController: UICollectionViewDelegate {
    
}

extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    
}
