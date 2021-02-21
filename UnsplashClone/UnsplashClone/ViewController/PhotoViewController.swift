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
    private var photos = [Photo]()
    var viewModel: PhotoViewModel!
    
    func bindViewModel() {
        viewModel.photoData.bind { [weak self] photos in
            self?.photos.append(contentsOf: photos)
        }
    }
    
    var kTableHeaderHeight: CGFloat = 300.0
    var headerView: UIView!
    
    @IBOutlet weak var photoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.fetchPhotoData(page: 1, perPage: 10)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            print(self.photos)
            self.reloadPhotos()
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
        reloadPhotos()
    }
    
    private func reloadPhotos() {
        var snapshot  = NSDiffableDataSourceSnapshot<Section, Photo>()
        snapshot.appendSections([.main])
        snapshot.appendItems(photos)
        self.dataSource.apply(snapshot)
    }
    
    enum Section: Hashable {
        case main
    }
}

extension PhotoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let photo = dataSource.itemIdentifier(for: indexPath) else {
            return .zero
        }
        
        let width = tableView.frame.width
        let ratio = CGFloat(photo.height) / CGFloat(photo.width)
        let height = width * ratio
        
        return height
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


