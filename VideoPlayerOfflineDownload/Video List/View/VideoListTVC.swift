//
//  VideoListTVC.swift
//  VideoPlayerOfflineDownload
//
//  Created by Niraj Kumar Jha on 13/12/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import UIKit

protocol VideoListCellDelegate: class {
    
}

class VideoListTVC: UITableViewCell {

    @IBOutlet private weak var videoNameLbl: UILabel!
    
    weak var delegate: VideoListCellDelegate?
   
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(from model: VideoListCellModel) {
        videoNameLbl.text = model.videoModel.title
    }

}
