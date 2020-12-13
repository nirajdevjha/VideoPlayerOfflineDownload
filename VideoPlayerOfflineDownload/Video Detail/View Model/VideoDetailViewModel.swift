//
//  VideoDetailViewModel.swift
//  VideoPlayerOfflineDownload
//
//  Created by Niraj Kumar Jha on 13/12/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import Foundation

class VideoDetailViewModel {
    private let videoModel: VideoModel
    
    init(videoModel: VideoModel) {
        self.videoModel = videoModel
    }
    
    var navigationTitle: String {
        return videoModel.title ?? "Video"
    }
    
    func getVideoUrl() -> URL? {
        guard let videoUrlStr = videoModel.video,
            let videoUrl = URL(string: videoUrlStr) else {
                return nil
        }
        return videoUrl
    }
    
}
