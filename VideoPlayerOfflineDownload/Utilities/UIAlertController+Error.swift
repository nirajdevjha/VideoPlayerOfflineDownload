//
//  UIAlertController+Error.swift
//  VideoPlayerOfflineDownload
//
//  Created by Niraj Kumar Jha on 14/12/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import UIKit

typealias VoidBlock = () -> Void 

extension UIAlertController {
    @objc
    class func showErrorMsgAlert(
        from viewController: UIViewController?, title: String, msg: String,
        okHandler: VoidBlock?) {
        guard let viewController = viewController else { return }
        let alertController = UIAlertController(
            title: title,
            message: msg,
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            okHandler?()
        }))
        viewController.present(alertController, animated: true)
    }
}

