//
//  ViewController.swift
//  UnsplashClone
//
//  Created by 박성민 on 2021/02/12.
//

import UIKit

class PhotoViewController: UIViewController, ViewModelBindableType {
    
    typealias PhotoDataSource = UITableViewDiffableDataSource<Section, Photo>
    
    private lazy var dataSource = createDataSource()
    private let perPage: Int = 10
    weak var coordinator: SceneCoordinatorType?
    var viewModel: PhotoViewModel!
    var kTableHeaderHeight: CGFloat = 300.0
    var headerView: UIView!
    
    @IBOutlet weak var photoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.fetchHeaderPhoto()
        viewModel.fetchPhotoData(page: 1, perPage: perPage)
    }
    
    func bindViewModel() {
        viewModel.photoData.bind { [weak self] photos in
            guard let self = self else { return }
            var snapshot = self.dataSource.snapshot()
            snapshot.appendItems(photos, toSection: .main)
            DispatchQueue.main.async {
                self.dataSource.apply(snapshot)
            }
        }
        
        viewModel.headerPhoto.bind { [weak self] photo in
            guard let self = self,
                  let photo = photo,
                  let headerView = self.headerView as? PhotoTableViewHeaderView
            else {
                return
            }
            
            DispatchQueue.main.async {
                headerView.configureUserLabel(username: photo.username)
                let width = Int(self.view.frame.width * UIScreen.main.scale)
                
                DispatchQueue.global().async {
                    self.viewModel.fetchImage(url: photo.photoURLs.regular, width: width) { result in
                        switch result {
                        case .success(let image):
                            DispatchQueue.main.async {
                                headerView.configureHeaderImage(image: image)
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            }
        }
    }
    
    private func configureTableView() {
        photoTableView.delegate = self
        photoTableView.rowHeight =
            UITableView.automaticDimension
        
        headerView = photoTableView.tableHeaderView
        photoTableView.tableHeaderView = nil
        photoTableView.addSubview(headerView)
        photoTableView.contentInset = UIEdgeInsets(top: kTableHeaderHeight, left: 0, bottom: 0, right: 0)
        photoTableView.contentOffset = CGPoint(x: 0, y: -kTableHeaderHeight)
        
        PhotoTableViewCell.registerNib(tableView: photoTableView)
        
        updateHeaderView()
        var snapshot = NSDiffableDataSourceSnapshot<Section, Photo>()
        snapshot.appendSections([.main])
        dataSource.apply(snapshot)
    }
    
    enum Section: Hashable {
        case main
    }
}

extension PhotoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let photo = dataSource.itemIdentifier(for: indexPath)
        else {
            return .zero
        }
        
        let width = tableView.frame.width
        let ratio = CGFloat(photo.height) / CGFloat(photo.width)
        let height = width * ratio
        
        return height
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.item == dataSource.tableView(tableView, numberOfRowsInSection: 0) - 1 {
            let page = Int(ceil(Double(dataSource.tableView(tableView, numberOfRowsInSection: 0)) / Double(perPage))) + 1
            viewModel.fetchPhotoData(page: page, perPage: perPage)
        }
        
        guard let photoCell = cell as? PhotoTableViewCell,
              let photo = dataSource.itemIdentifier(for: indexPath)
        else {
            return
        }
        
        let width = Int(view.frame.width * UIScreen.main.scale)
        DispatchQueue.global().async { [weak self] in
            self?.viewModel.fetchImage(url: photo.photoURLs.regular, width: width) { result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        photoCell.configureCell(image: image)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailScene = Scene.detail
        coordinator?.transition(to: detailScene, using: .modal, animated: true)
        
    }
    
    
}

extension PhotoViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func updateHeaderView() {
        
        var headerRect = CGRect(x: 0, y: -kTableHeaderHeight, width: photoTableView.bounds.width, height: kTableHeaderHeight)
        if photoTableView.contentOffset.y < -kTableHeaderHeight {
            headerRect.origin.y = photoTableView.contentOffset.y
            headerRect.size.height = -photoTableView.contentOffset.y
        }
        
        headerView.frame = headerRect
    }
}

extension PhotoViewController {
    func createDataSource() -> PhotoDataSource {
        let dataSource = PhotoDataSource(
            tableView: photoTableView,
            cellProvider: { (tableView, indexPath, photo) -> UITableViewCell? in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.Identifier.reusableCell, for: indexPath) as? PhotoTableViewCell else { return UITableViewCell() }
                
                cell.configureCell(username: photo.username, sponsored: photo.sponsored, imageSize: cell.frame.size)
                return cell
            }
        )
        return dataSource
    }
}
