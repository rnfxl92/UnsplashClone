//
//  DetailViewController.swift
//  UnsplashClone
//
//  Created by 박성민 on 2021/02/26.
//

import UIKit

final class DetailViewController: UIViewController, ViewModelBindableType {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var navigationTitleItem: UINavigationItem!
    @IBOutlet weak var detailCollectionView: UICollectionView!
    
    weak var coordinator: SceneCoordinatorType?
    var dataSource: PhotoCollectionViewDataSource?
    var viewModel: PhotoViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureTransparentNavigationBar()
    }
    
    func bindViewModel() {
        viewModel.photoData.bind { [weak self] photos in
            guard let self = self else { return }
            guard var snapshot = self.dataSource?.snapshot() else {
                return
            }
            snapshot.appendItems(photos, toSection: .main)
            DispatchQueue.main.async {
                self.dataSource?.apply(snapshot)
            }
        }
    }
        
    private func configureCollectionView() {
        detailCollectionView.delegate = self
        detailCollectionView.dataSource = self
    }
    
    private func configureTransparentNavigationBar() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
    }
    
    @IBAction func closeButtonDidTap(_ sender: Any) {
        coordinator?.close(animated: true)
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
