//
//  VideoListInteractor.swift
//  VideoPlayerOfflineDownload
//
//  Created by Niraj Kumar Jha on 13/12/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import Foundation

class VideoListInteractor: VideoListInteractorInputProtocol {
    weak var presenter: VideoListInteractorOutputProtocol?
    var remoteDatamanager: VideoListDataManagerProtocol?
    var videoListResponse: VideoListResponseModel?
    
    func fetchVideoListAPI() {
        remoteDatamanager?.fetchVideoListAPI(completion: { (result: Result<VideoListResponseModel, VideoListAPIError>) in
            self.videoListResponseHandler(result)
        })
    }
    
    private func videoListResponseHandler(_ result: Result<VideoListResponseModel, VideoListAPIError>) {
        switch result {
        case .success(let responseModel):
            videoListResponse = responseModel
            presenter?.didReceiveVideoListResponse(responseModel)
        case .failure(let error):
            presenter?.didFailToReceiveVideoListResponse(error: error)
        }
    }
}
