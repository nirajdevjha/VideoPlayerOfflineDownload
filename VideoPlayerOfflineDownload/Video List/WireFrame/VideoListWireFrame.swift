//
//  VideoListWireFrame.swift
//  VideoPlayerOfflineDownload
//
//  Created by Niraj Kumar Jha on 13/12/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import UIKit

class VideoListWireFrame: InternalVideoListWireFrameProtocol {
    
    static func createVideoListModule(videoListRef: VideoListView) {
        
        let presenter: VideoListPresenterProtocol & VideoListInteractorOutputProtocol = VideoListPresenter()
        let interactor: VideoListInteractorInputProtocol = VideoListInteractor()
        let remoteDataManager: VideoListDataManagerProtocol = VideoListDataManager()
        let wireFrame: InternalVideoListWireFrameProtocol = VideoListWireFrame()
        
        videoListRef.presenter = presenter
        presenter.view = videoListRef
        presenter.wireFrame = wireFrame
        presenter.interactor = interactor
        interactor.presenter = presenter
        interactor.remoteDatamanager = remoteDataManager
    }
    
    func openVideoDetail(view: VideoListViewProtocol, viewModel: VideoDetailViewModel) {
        guard let sourceView = view as? UIViewController else {
            return
        }
        let videoDetailVC = VideoDetailVC.controller(viewModel: viewModel)
        sourceView.navigationController?.pushViewController(videoDetailVC, animated: true)
    }
}
