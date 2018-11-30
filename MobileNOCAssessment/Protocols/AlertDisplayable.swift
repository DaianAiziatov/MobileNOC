//
//  AlertDisplayer.swift
//  MobileNOCAssessment
//
//  Created by Daian Aiziatov on 28/11/2018.
//  Copyright © 2018 Daian Aiziatov. All rights reserved.
//

import Foundation
import UIKit

protocol AlertDisplayable {
    func displayAlert(with title: String, message: String, actions: [UIAlertAction]?)
}

extension AlertDisplayable where Self: UIViewController {
    func displayAlert(with title: String, message: String, actions: [UIAlertAction]? = nil) {
        guard presentedViewController == nil else {
            return
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions?.forEach { action in
            alertController.addAction(action)
        }
        present(alertController, animated: true)
    }
}
