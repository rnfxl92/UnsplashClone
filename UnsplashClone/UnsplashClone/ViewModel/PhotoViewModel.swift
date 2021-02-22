//
//  PhotoViewModel.swift
//  UnsplashClone
//
//  Created by 박성민 on 2021/02/21.
//

import UIKit

class PhotoViewModel {
    
    let sceneCoordinator: SceneCoordinatorType
    let photoService: PhotoServicing
    let imageService: ImageServicing
    let photoData: Box<[Photo]> = Box([])
    
    init(sceneCoordinator: SceneCoordinator, photoService: PhotoServicing, imageService: ImageServicing) {
        self.sceneCoordinator = sceneCoordinator
        self.photoService = photoService
        self.imageService = imageService
    }
    
    func fetchPhotoData(page: Int, perPage: Int) {
        photoService.fetchPhotos(page: page, perPage: perPage) {[weak self] result in
            switch result {
            case .success(let photos):
                self?.photoData.value = photos
            case .failure(let error):
                print(error)
                return
            }
        }
    }
    
    func fetchImage(url: String, width: Int, completion: @escaping (Result<UIImage?, NetworkError>) -> Void) {
        let endPoint = UnsplashEndPoint.photoURL(url: url, width: width)
        imageService.imageURL(endPoint: endPoint, completion: completion)
    }
    
    func fetchHeaderPhoto(width: Int, completion: @escaping (Result<UIImage?, NetworkError>) -> Void) {
        photoService.fetchRandomPhoto() { [weak self] result in
            switch result {
            case .success(let photo):
                self?.fetchImage(url: photo.photoURLs.regular, width: width) { result in
                    switch result {
                    case .success(let image):
                        completion(.success(image))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}