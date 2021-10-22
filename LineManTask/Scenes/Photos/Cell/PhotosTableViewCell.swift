//
//  PhotosTableViewCell.swift
//  LineManTask
//
//  Created by Adinarayana Machavarapu on 15/10/21.
//

import UIKit

class PhotosTableViewCell: UITableViewCell {

    @IBOutlet weak var photoNameLabel: UILabel!
    @IBOutlet weak var photoDescriptionLabel: UILabel!
    @IBOutlet weak var photoLikesLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
  
    var photosDisplayViewModel : PhotosDisplayViewModel! {
        didSet {
            self.photoNameLabel.text   = photosDisplayViewModel.name
            self.photoNameLabel.font = UIFont(name: "Roboto-Bold", size: 16)
            self.photoDescriptionLabel.text = photosDisplayViewModel.photoDescription
            self.photoDescriptionLabel.font = UIFont(name: "Roboto-Regular", size: 12)
            self.photoLikesLabel.text = photosDisplayViewModel.votesCount
            self.photoLikesLabel.font = UIFont(name: "Roboto-Regular", size: 10)
            self.photoImageView.downloadImage(url: photosDisplayViewModel.imageUrl)
        }
    }
}
