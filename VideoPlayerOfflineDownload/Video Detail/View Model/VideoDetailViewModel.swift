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
    private let localVideoUrl: URL?
    
    init(videoModel: VideoModel, localVideoUrl: URL?) {
        self.videoModel = videoModel
        self.localVideoUrl = localVideoUrl
    }
    
    var navigationTitle: String {
        return videoModel.title ?? "Video"
    }
    
    func getVideoUrl() -> URL? {
        // if localVideoUrl, feed this to player
        if let localVideoUrl = localVideoUrl {
            return localVideoUrl
        }
        guard let videoUrlStr = videoModel.video,
            let videoUrl = URL(string: videoUrlStr) else {
                return nil
        }
        return videoUrl
    }
    
}
