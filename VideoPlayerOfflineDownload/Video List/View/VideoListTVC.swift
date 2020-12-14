//
//  VideoListTVC.swift
//  VideoPlayerOfflineDownload
//
//  Created by Niraj Kumar Jha on 13/12/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import UIKit

protocol VideoListCellDelegate: class {
    func startDownload(with videoModel: VideoModel, resource: DownloadResource)
}

class VideoListTVC: UITableViewCell {

    @IBOutlet private weak var videoNameLbl: UILabel!
    @IBOutlet private weak var downloadButton: UIButton!
    @IBOutlet private weak var downloadProgressView: CircularProgressbarView!
    @IBOutlet private weak var taskStateLabel: UILabel!
   
    weak var delegate: VideoListCellDelegate?
    
    private var videoModel: VideoModel?
    var resource: DownloadResource!
    var reuse: ((VideoListTVC) -> Void)?
   
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resource = nil
        reuse?(self)
    }
    
    func configure(from model: VideoListCellModel) {
        videoModel = model.videoModel
        videoNameLbl.text = videoModel?.title
        taskStateLabel.isHidden = false
        taskStateLabel.text = "Not Downloaded"
        downloadButton.isHidden = false
        downloadProgressView.isHidden = true
    }

    @IBAction
    private func didTapDownload(_ sender: UIButton) {
        guard let videoModel = videoModel else { return }
        delegate?.startDownload(with: videoModel, resource: resource)
    }
}

extension VideoListTVC {
    func bindWith(downloadResource resource: DownloadResource) {
        downloadProgressView.isHidden = true
        self.resource = resource
        if let _ = FileManager.cedricPath(forResourceWithName: resource.destinationName) {
            downloadButton.isHidden = true
            taskStateLabel.isHidden = false
            taskStateLabel.text = "Downloaded"
        }
    }
    
    func bindWith(task: URLSessionDownloadTask) {
        switch task.state {
        case .canceling:
            downloadProgressView.isHidden = true
            setUpTaskState("Canceling")
            taskStateLabel.text = "Canceling"
        case .suspended:
            downloadProgressView.isHidden = true
            setUpTaskState("Waiting for download")
        case .running:
            let progress = Float(task.countOfBytesReceived) / Float(task.countOfBytesExpectedToReceive)
            if progress >= 0.0 && progress <= 1.0 {
                setUpTaskState("Downloading")
                downloadProgressView.isHidden = false
                downloadProgressView.progress = progress
            }
        case .completed:
            downloadProgressView.isHidden = true
            if task.countOfBytesExpectedToReceive == task.countOfBytesReceived {
                taskStateLabel.text = "Downloaded"
                setUpTaskState("Downloaded")
            } else {
                setUpTaskState(task.error?.localizedDescription ?? "Some error occured")
                taskStateLabel.text = task.error?.localizedDescription ?? "Some error occured"
            }
        @unknown default:
            break
        }
    }
    
    private func setUpTaskState(_ msg: String) {
        taskStateLabel.isHidden = false
        downloadButton.isHidden = true
        taskStateLabel.text = msg
    }
    
    fileprivate func bindWith(downloadedFile file: DownloadedFile) {
        downloadProgressView.isHidden = true
        do {
            let url = try file.url()
            downloadProgressView.isHidden = true
            setUpTaskState("Downloaded")
        } catch let error {
            setUpTaskState(error.localizedDescription)
        }
    }
}

extension VideoListTVC: CedricDelegate {
    func cedric(_ cedric: Cedric, didStartDownloadingResource resource: DownloadResource, withTask task: URLSessionDownloadTask) {
        guard resource == self.resource else { return }
        bindWith(task: task)
    }
    
    func cedric(_ cedric: Cedric, didUpdateStatusOfTask task: URLSessionDownloadTask, relatedToResource resource: DownloadResource) {
        guard resource == self.resource else { return }
        bindWith(task: task)
    }
    
    func cedric(_ cedric: Cedric, didFinishDownloadingResource resource: DownloadResource, toFile file: DownloadedFile) {
        guard resource == self.resource else { return }
        bindWith(downloadedFile: file)
    }
}

