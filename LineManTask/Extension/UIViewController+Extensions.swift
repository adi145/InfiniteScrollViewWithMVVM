//
//  UIViewController+Extensions.swift
//  PomeloTask
//
//  Created by Adinarayana Machavarapu on 11/10/21.
//

import UIKit

extension UIViewController {
    /**
     This is used to display alert with title and message with multiple button based on requirement
     
     - parameter title:   title string
     - parameter message: message string
     */
    func popupAlert(title: String?, message: String?, actionTitles:[String?], actions:[((UIAlertAction) -> Void)?]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: actions[index])
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }
}


