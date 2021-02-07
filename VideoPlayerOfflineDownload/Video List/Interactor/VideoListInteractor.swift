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
        //check for internet
        guard ReachabilityManager.shared.checkNetworkConnection else {
            retriveVideoListFromUserDefaults()
            return
        }
        remoteDatamanager?.fetchVideoListAPI(completion: { [weak self] result in
            self?.videoListResponseHandler(result)
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
            //Storing videoListResponse in user defaults
            if let encoded = try? JSONEncoder().encode(videoListResponse) {
                UserDefaults.standard.set(encoded, forKey: "videoList")
            }
            presenter?.didReceiveVideoListResponse(responseModel)
        case .failure(let error):
            presenter?.didFailToReceiveVideoListResponse(error: error)
        }
    }
    
    @discardableResult
    private func retriveVideoListFromUserDefaults() -> Bool {
        do {
            let videoList = UserDefaults.standard.object(forKey: "videoList")
            if videoList == nil {
                return false
            }
            let responseModel = try JSONDecoder().decode(VideoListResponseModel.self, from: videoList as! Data)
            videoListResponse = responseModel
            if let videoListResponse = videoListResponse {
                presenter?.didReceiveVideoListResponse(videoListResponse)
            }
            return true
        } catch let err {
            debugPrint(err)
            return false
        }
    }
}
