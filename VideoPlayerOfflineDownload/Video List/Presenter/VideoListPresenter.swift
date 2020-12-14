//
//  VideoListPresenter.swift
//  VideoPlayerOfflineDownload
//
//  Created by Niraj Kumar Jha on 13/12/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import Foundation
import UIKit

class VideoListPresenter: VideoListPresenterProtocol {
    
    var interactor: VideoListInteractorInputProtocol?
    weak var view: VideoListViewProtocol?
    var wireFrame: InternalVideoListWireFrameProtocol?
    
    private var sections = [VideoListCardPresenterProtocol]()
    
    func viewDidLoad() {
        interactor?.fetchVideoListAPI()
    }
    
    func viewWillAppear() {
    }
    
    func viewWillDisappear() {
    }
    
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfCardInSection(_ section: Int) -> Int {
        guard sections.count > section else {
            return 0
        }
        return sections[section].numberOfCells()
    }
    
    func sectionDetailAtIndex(_ section: Int) -> VideoListCardPresenterProtocol? {
        guard sections.count > section else {
            return nil
        }
        return sections[section]
    }
    
    func sectionFooterHeight(_ section: Int) -> CGFloat {
        return sections[section].sectionFooterHeight(section)
    }
    
    func cellModelAtIndex(_ indexPath: IndexPath) -> (VideoListRowModel, VideoListCardPresenterProtocol)? {
        sections[indexPath.section].section = indexPath.section
        return sections[indexPath.section].cellModelForRowAtIndex(indexPath.row)
    }
    
    func clearDownloadsTapped() {
        interactor?.clearDownloadsTapped()
    }
    
    private func prepareSections(from videoModels: [VideoModel]?) {
        guard let interactor = interactor,
            let videoModels = videoModels,
            !videoModels.isEmpty else {
                return
        }
        sections.removeAll()
        let videoListCardPresenter = VideoListCardPresenter(sectionType: .videoList, section: 0, videoModels: videoModels, delegate: self, cedric: interactor.cedric)
        sections.append(videoListCardPresenter)
    }

}

//MARK:- Interactor Output Methods
extension VideoListPresenter: VideoListInteractorOutputProtocol {
    func didReceiveVideoListResponse(_ response: VideoListResponseModel) {
        view?.hideLoading()
        view?.enableUserInteraction()
        prepareSections(from: response)
        view?.reloadPage()
    }
    
    func didFailToReceiveVideoListResponse(error: VideoListAPIError) {
        view?.hideLoading()
        view?.enableUserInteraction()
        var message: String = "Something went wrong"
        switch error {
        case .failedWith(errorMessage: let errorMessage, errorCode: _):
            message = errorMessage
        default: break
        }
        view?.showErrorMsg(message)
    }
    
    func reloadDataModels(_ response: VideoListResponseModel) {
        prepareSections(from: response)
        view?.reloadPage()
    }
}

extension VideoListPresenter: VideoListSectionProtocol {
    func openVideoDetail(video: VideoModel, localVideoUrl: URL?) {
        guard let view = view else {
            return
        }
        let videoDetailVM = VideoDetailViewModel(videoModel: video, localVideoUrl: localVideoUrl)
        wireFrame?.openVideoDetail(view: view, viewModel: videoDetailVM)
    }
    
    func startDownload(with videoModel: VideoModel, resource: DownloadResource) {
        interactor?.addVideoForDownload(video: videoModel, resource: resource)
    }
}
