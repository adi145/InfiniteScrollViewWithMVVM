//
//  PhotosViewModel.swift
//  LineManTask
//
//  Created by Adinarayana Machavarapu on 15/10/21.
//

import Foundation

protocol PhotosViewModelProtocol {
    func showAlert(errorMessage: String)
    func showLoading(isLoading: Bool)
    func reloadtableView()
}

protocol PhotosApiProtocol {
    func fetchPhotos(pagenation:Bool, isLoading:Bool)
}

class PhotosViewModel {
    let featureValue = "popular"
    let networkClient: NetworkClient
    var photos = [Photo]()
    var currentPage = 1
    var isPaginating = false
    var photosViewModelDelegate: PhotosViewModelProtocol!
    var photosDisplayViewModel: [PhotosDisplayViewModel] = [PhotosDisplayViewModel]()

    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
    
    /**
    returning total photos count
        
     - returns: photosDisplayViewModel count
     */
    var numberOfCells: Int {
        return photosDisplayViewModel.count
    }
    
    /**
   Get indexpath from the cell and returning with  photos to display photos details
     
     - parameter indexPath: IndexPath
     
     - returns: PhotosDisplayViewModel
     */
    func getCellViewModel( at indexPath: IndexPath ) -> PhotosDisplayViewModel {
        return photosDisplayViewModel[indexPath.row]
    }
    
}

extension PhotosViewModel: PhotosApiProtocol {
  
    /**
      Fetch photos details from server based on pagination and appending response to photos.
      */
    func fetchPhotos(pagenation:Bool, isLoading:Bool) {
        if pagenation {
            self.isPaginating = true
        }
        self.photosViewModelDelegate.showLoading(isLoading: isLoading)
        let featureQueryParams = ["feature": featureValue]
        let pagesQueryParams = ["page": currentPage]
        networkClient.request(type: PhotosModel.self, service: ApiEndpoints.photos(pages: [featureQueryParams, pagesQueryParams])) { [weak self] response in
            switch response {
            case.success(let photosModel):
                DispatchQueue.main.async {
                    self?.photosViewModelDelegate.showLoading(isLoading: false)
                    guard let moreStatus = self?.isPaginating else {
                        return
                    }
                    if photosModel.photos.count == 0 && moreStatus {
                        self?.currentPage -= 1
                        self?.photosViewModelDelegate.showAlert(errorMessage:AppConstants.noMorePagination)
                        return
                    } else if photosModel.photos.count == 0 {
                        self?.photosViewModelDelegate.showAlert(errorMessage: AppConstants.someThingWentWrong)
                        return
                    }
                    self?.photos.append(contentsOf: photosModel.photos)
                    self?.getPhotoDisplayViewModelList(response: photosModel.photos )
                    self?.photosViewModelDelegate.reloadtableView()
                    self?.isPaginating = false
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.photosViewModelDelegate.showLoading(isLoading: false)
                    self?.isPaginating = false
                    let errorMessage = NetworkError.getTheErrorMessage(error: error)
                    self?.photosViewModelDelegate.showAlert(errorMessage: errorMessage)
                }
            }
        }
    }
    
    /**
     This method used to create list of PhotosDisplayViewModel and appeding new response with current values.
     
     - parameter response: Photo Model
     
     - returns: Array of PhotosDisplayViewModel
     */
    private func getPhotoDisplayViewModelList(response: [Photo]){
        var indexArray = [Int]()
        let totalCount =  self.photosDisplayViewModel.count-1 + response.count-1
     
        for index in self.photosDisplayViewModel.count..<totalCount {
            if index != 0{
                if index % 5 == 0 {
                    indexArray.append(index)
                }
            }
        }
        
        for photo in response {
            var imageUrl = ""
            if photo.imageURL.count > 0 {
                imageUrl = photo.imageURL[0]
            }
            let object = PhotosDisplayViewModel(name: photo.name, photoDescription: photo.photoDescription, imageUrl: imageUrl, votesCount: String(photo.votesCount))
            self.photosDisplayViewModel.append(object)
        }
        
        for index in indexArray {
            self.photosDisplayViewModel.insert(PhotosDisplayViewModel(name: "", photoDescription: "", imageUrl: "", votesCount: ""), at: index)
        }
    }
}
