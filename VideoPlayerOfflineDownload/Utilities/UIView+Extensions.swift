//
//  UIView+Extensions.swift
//  VideoPlayerOfflineDownload
//
//  Created by Niraj Kumar Jha on 13/12/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import UIKit

public protocol NibLoadView: class { }

public extension NibLoadView {
    static var nibName: String {
        return String(describing: self)
    }
}

extension UIView: NibLoadView {}

protocol ReuseView: class { }

extension ReuseView where Self: UIView {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReuseView { }

extension UITableView {
    
    func register<T: UITableViewCell>(_: T.Type, bundle: Bundle? = nil) {
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        register(nib, forCellReuseIdentifier: T.identifier)
    }
    
    func dequeueReuseCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("failed to dequeue cell with identifier: \(T.identifier)")
        }
        return cell
    }
}

