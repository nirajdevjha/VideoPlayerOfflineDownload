//
//  VideoListCellModels.swift
//  VideoPlayerOfflineDownload
//
//  Created by Niraj Kumar Jha on 13/12/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import Foundation

class VideoListCellModel: VideoListRowModel {
    var type: VideoListRowModelType
    let videoModel: VideoModel
    var localVideoUrl: URL?
    var cedric: Cedric
    var resource: DownloadResource
    
    init(type: VideoListRowModelType, videoModel: VideoModel, cedric: Cedric, resource: DownloadResource, localVideoUrl: URL?) {
        self.type = type
        self.videoModel = videoModel
        self.cedric = cedric
        self.resource = resource
        self.localVideoUrl = localVideoUrl
    }
}
