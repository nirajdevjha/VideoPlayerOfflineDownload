//
//  VideoListCellBuilder.swift
//  VideoPlayerOfflineDownload
//
//  Created by Niraj Kumar Jha on 13/12/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import UIKit

struct VideoListCellBuilder {
    static func registerCells(to tableView: UITableView) {
        tableView.register(VideoListTVC.self, bundle: .main)
    }
    
    static func getTableViewCell(atIndexPath indexPath: IndexPath, from cellViewModel: VideoListRowModel, forTableView tableView: UITableView, actionDelegate: VideoListCardPresenterProtocol) -> UITableViewCell {
        switch cellViewModel.type {
            
        case .list:
            if let cellViewModel = cellViewModel as? VideoListCellModel {
                let cell: VideoListTVC = tableView.dequeueReuseCell(forIndexPath: indexPath)
                cell.delegate = actionDelegate as? VideoListCardPresenter
                cell.configure(from: cellViewModel)
                cell.bindWith(downloadResource: cellViewModel.resource)
                if let task = cellViewModel.cedric.downloadTask(forResource: cellViewModel.resource) {
                    cell.bindWith(task: task)
                }
                
                cellViewModel.cedric.addDelegate(cell)
                cell.reuse = {  c in
                    cellViewModel.cedric.removeDelegate(c)
                }
                return cell
            }
        }
        
        return UITableViewCell()
    }
}


