//
//  PhotoViewModel.swift
//  UnsplashClone
//
//  Created by 박성민 on 2021/02/21.
//

import UIKit

class PhotoViewModel {
    
    //let sceneCoordinator: SceneCoordinatorType
    let photoService: PhotoServicing
    let imageService: ImageServicing
    let photoData: Box<[Photo]> = Box([])
    
    init(photoService: PhotoServicing, imageService: ImageServicing) {
        //self.sceneCoordinator = sceneCoordinator
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
    
}
