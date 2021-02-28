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
    lazy var dataSource = createDataSource()
    var viewModel: PhotoViewModel!
    var defaultIndexPath: IndexPath?
    var firstCall = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureTransparentNavigationBar()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if firstCall {
            scrollToDefaultPhoto()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func bindViewModel() {
        viewModel.photoData.bind { [weak self] photos in
            guard let self = self else { return }
            var snapshot = NSDiffableDataSourceSnapshot<Section, Photo>()
            snapshot.appendSections([.main])
            snapshot.appendItems(photos)
            DispatchQueue.main.async {
                self.dataSource.apply(snapshot)
            }
        }
    }
    
    func scrollToDefaultPhoto() {
        guard let defaultIndexPath = defaultIndexPath,
              let photo = dataSource.itemIdentifier(for: defaultIndexPath) else {
            return
        }

        detailCollectionView.scrollToItem(at: defaultIndexPath, at: .left, animated: false)
        navigationTitleItem.title = photo.username
        firstCall = false
    }
    
    private func configureCollectionView() {
        detailCollectionView.delegate = self
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

        return CGSize(width: detailCollectionView.frame.width, height: detailCollectionView.frame.height)
    }
}

extension DetailViewController: UICollectionViewDelegate {
    
}

extension DetailViewController {
    func createDataSource() -> PhotoCollectionViewDataSource {
        let dataSource = PhotoCollectionViewDataSource(
            collectionView: detailCollectionView,
            cellProvider: { [unowned self] (collectionView, indexPath, photo) in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCollectionViewCell.Identifier.reusableCell, for: indexPath)
                        as? DetailCollectionViewCell else { return UICollectionViewCell() }
                
                let width = Int(self.view.frame.width * UIScreen.main.scale)
                DispatchQueue.global().async {
                    self.viewModel.fetchImage(url: photo.photoURLs.raw, width: width) { result in
                        switch result {
                        case .success(let image):
                            DispatchQueue.main.async {
                                cell.configureImage(image: image)
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
                
                return cell
            })
        return dataSource
    }
}
