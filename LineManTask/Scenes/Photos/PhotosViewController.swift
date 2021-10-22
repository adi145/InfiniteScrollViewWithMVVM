//
//  PhotosViewController.swift
//  LineManTask
//
//  Created by Adinarayana Machavarapu on 15/10/21.
//

import UIKit

class PhotosViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var photosTableView: UITableView!

    lazy var photosViewModel: PhotosViewModel = {
        return PhotosViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupViewModel()
    }
    /**
     This method is used to setup UI & registering the custom tableview cell.
     */
    private func setupUI() {
        self.title = AppConstants.title
        self.activityIndicator.center = self.view.center
        photosTableView.register(UINib(nibName: AppConstants.photosReusableIdentifier, bundle: nil), forCellReuseIdentifier: AppConstants.photosReusableIdentifier)
        photosTableView.register(UINib(nibName: AppConstants.imageInsertionReusableIdentifier, bundle: nil), forCellReuseIdentifier: AppConstants.imageInsertionReusableIdentifier)
    }
    
    /**
     This method is used to setup viewmodel and call the api to fetch photos.
     */
    private func setupViewModel() {
        self.photosViewModel.photosViewModelDelegate = self
        photosViewModel.fetchPhotos(pagenation: true, isLoading: true)
    }
}

extension PhotosViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.photosViewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return getPhotosTableViewCell(tableView: tableView, indexPath: indexPath)
        } else if indexPath.row % 5 == 0 {
            return getImageInsertionTableViewCell(tableView: tableView, indexPath: indexPath)
        } else {
            return getPhotosTableViewCell(tableView: tableView, indexPath: indexPath)
        }
    }
    /**
     This method is going to return new PhotosTableViewCell every cellforrowatindex called based on condition.
     - parameter tableView: UITableView
     - parameter indexPath: indexPath

     - returns: PhotosTableViewCell
     */
    private func getPhotosTableViewCell(tableView: UITableView, indexPath:IndexPath) -> PhotosTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:AppConstants.photosReusableIdentifier, for: indexPath) as? PhotosTableViewCell else {
            fatalError("Cell not exists in storyboard")
        }
        let cellVM = photosViewModel.getCellViewModel( at: indexPath)
        cell.photosDisplayViewModel = cellVM
        return cell
    }
    /**
     This method is going to return new ImageInsertTableViewCell every cellforrowatindex called based on condition.
     - parameter tableView: UITableView
     - parameter indexPath: indexPath

     - returns: ImageInsertTableViewCell
     */
    private func getImageInsertionTableViewCell(tableView: UITableView, indexPath:IndexPath) -> ImageInsertTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:AppConstants.imageInsertionReusableIdentifier, for: indexPath) as? ImageInsertTableViewCell else {
            fatalError("Cell not exists in storyboard")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    /**
        Creating new view with indicator and add to tableview footerview to show the customer when scrolling to tableview bottom fetch new photos from api.
     - returns: UIView
      */
    private func createIndicatorForTableViewFooter() -> UIView{
        let spinnerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 100))
        let footerViewIndicator = UIActivityIndicatorView()
        footerViewIndicator.center = spinnerView.center
        footerViewIndicator.style = .large
        footerViewIndicator.color = UIColor(red: 92/255, green: 197/255, blue: 110/255, alpha: 1)
        spinnerView.addSubview(footerViewIndicator)
        footerViewIndicator.startAnimating()
        return spinnerView
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (photosTableView.contentSize.height-100-scrollView.frame.size.height) {
            guard !photosViewModel.isPaginating else {
                return
            }
            self.photosTableView.tableFooterView = createIndicatorForTableViewFooter()
            self.photosViewModel.currentPage += 1
            self.photosViewModel.fetchPhotos(pagenation: true, isLoading: false)
        }
    }
}

extension PhotosViewController: PhotosViewModelProtocol{
    
    /**
        This is used to reload tablview everytime new data append to current data when customer request more photos by scrolling bottom of the tableview.
      */
    func reloadtableView() {
        DispatchQueue.main.async {
            self.photosTableView.tableFooterView = nil
            self.photosTableView.reloadData()
        }
    }
    /**
        This is used to show indictor to customer while fecthing data from api.
      */
    func showLoading(isLoading: Bool) {
        DispatchQueue.main.async {
            if isLoading {
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
                UIView.animate(withDuration: 0.2, animations: {
                    if self.photosViewModel.photosDisplayViewModel.count == 0{
                        self.photosTableView.alpha = 0.0
                    }
                })
            }else {
                self.photosTableView.tableFooterView = nil
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                UIView.animate(withDuration: 0.2, animations: {
                    self.photosTableView.alpha = 1.0
                })
            }
        }
    }
    /**
        This is used to present error message to customer when api return error.
      */
    func showAlert(errorMessage: String) {
        DispatchQueue.main.async {
                self.popupAlert(title: nil, message: errorMessage, actionTitles: ["Ok"], actions: [{ (action) in
                    // print("Ok Tapped")
                }])
            }
        }
    }

