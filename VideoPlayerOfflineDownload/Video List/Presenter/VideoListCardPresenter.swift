//
//  VideoListCardPresenter.swift
//  VideoPlayerOfflineDownload
//
//  Created by Niraj Kumar Jha on 13/12/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import Foundation

class VideoListCardPresenter: VideoListCardPresenterProtocol {
    var sectionType: VideoListSectionType
    var section: Int
    private var rowModels: [VideoListRowModel]
    weak var delegate: VideoListSectionProtocol?
    
    init(sectionType: VideoListSectionType, section: Int, videoModels: [VideoModel], delegate: VideoListSectionProtocol?, cedric: Cedric) {
        self.sectionType = sectionType
        self.section = section
        self.rowModels = [VideoListRowModel]()
        self.delegate = delegate
        prepareRowModels(from: videoModels, cedric: cedric)
    }
    
    func numberOfCells() -> Int {
        return rowModels.count
    }
    
    func cellModelForRowAtIndex(_ index: Int) -> (VideoListRowModel, VideoListCardPresenterProtocol)? {
        guard rowModels.count > index else {
            return nil
        }
        return (rowModels[index], self)
    }
    
    private func prepareRowModels(from videoModels: [VideoModel], cedric: Cedric) {
        rowModels.removeAll()
        for videoModel in videoModels {
            if let videoUrlStr = videoModel.video , let videoUrl = URL(string: videoUrlStr), let title = videoModel.title {
                let resource = DownloadResource(id: videoModel.id, source: videoUrl, destinationName: title + ".mp4")
                var localVideoUrl: URL?
                if let url = FileManager.cedricPath(forResourceWithName: resource.destinationName) {
                  localVideoUrl = url
                }
                //in offline mode, add only downloaded cell models
                if localVideoUrl == nil && !ReachabilityManager.shared.checkNetworkConnection {
                    continue
                }
                let videoListModel = VideoListCellModel(type: .list, videoModel: videoModel, cedric: cedric, resource: resource, localVideoUrl: localVideoUrl)
                rowModels.append(videoListModel)
            }
        }
    }
    
    func didSelectCellAtIndexpath(_ indexPath: IndexPath) {
        guard indexPath.row < rowModels.count else { return }
        let rowModel = rowModels[indexPath.row]
        if let rowModel = rowModel as? VideoListCellModel {
            delegate?.openVideoDetail(video: rowModel.videoModel, localVideoUrl: rowModel.localVideoUrl)
        }
    }
}

extension VideoListCardPresenter: VideoListCellDelegate {
    func startDownload(with videoModel: VideoModel, resource: DownloadResource) {
        delegate?.startDownload(with: videoModel, resource: resource)
    }
    
    func updateDownloadedVideoURl(url: URL, videoId: String?) {
        let filteredRowModel = rowModels.filter { rowModel -> Bool in
            if let rowModel = rowModel as? VideoListCellModel {
                return rowModel.videoModel.id == videoId
            }
            return false
        }.first
        if let filteredRowModel = filteredRowModel as? VideoListCellModel {
            filteredRowModel.localVideoUrl = url
        }
    }
}
