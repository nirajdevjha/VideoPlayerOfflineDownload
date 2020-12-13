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
    
    init() {
    }
    
    lazy var cedric: Cedric = {
        // max 3 parallel downloads
        let configuration = CedricConfiguration(mode: .parallel(max: 3))
        return Cedric(configuration: configuration)
    }()
    
    func fetchVideoListAPI() {
        remoteDatamanager?.fetchVideoListAPI(completion: { (result: Result<VideoListResponseModel, VideoListAPIError>) in
            self.videoListResponseHandler(result)
        })
    }
    
    func addVideoForDownload(video: VideoModel, resource: DownloadResource) {
        do {
            try cedric.enqueueDownload(forResource: resource)
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
    
    func clearDownloadsTapped() {
        try? cedric.cleanDownloadsDirectory()
        guard let videoListResponse = videoListResponse else { return }
        presenter?.reloadDataModels(videoListResponse)
    }
    
}

//MARK:- Private
extension VideoListInteractor {
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
