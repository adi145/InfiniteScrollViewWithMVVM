//
//  UIIMageView+Extension.swift
//  LineManTask
//
//  Created by Adinarayana Machavarapu on 16/10/21.
//

import UIKit
import Kingfisher

extension UIImageView {

    // Asynchronous image downloading and caching.
    func downloadImage(url:String) {
        let url = URL(string: url)
        self.kf.indicatorType = .activity
        self.kf.setImage(with: url, placeholder:UIImage(named: "photos_placeholder_image"))
    }
}
