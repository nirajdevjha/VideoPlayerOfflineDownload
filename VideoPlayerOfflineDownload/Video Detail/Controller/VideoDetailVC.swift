//
//  VideoDetailVC.swift
//  VideoPlayerOfflineDownload
//
//  Created by Niraj Kumar Jha on 13/12/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class VideoDetailVC: UIViewController {
    
    @IBOutlet private weak var videoPlaceHolderView: UIView!
    
    var avPlayer: AVPlayer = AVPlayer()
    var playerController: AVPlayerViewController?
    var paused: Bool = false
    
    var videoPlayerItem: VideoPlayerItem? = nil {
        didSet {
            avPlayer.replaceCurrentItem(with: self.videoPlayerItem)
        }
    }
    
    static let assetKeysRequiredToPlay = [
        "playable",
        "hasProtectedContent"
    ]
    
    var asset: AVURLAsset? {
        didSet {
            guard let newAsset = asset else { return }
            asynchronouslyLoadURLAsset(newAsset)
        }
    }
    
    var viewModel: VideoDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.navigationTitle
        setupVideoController()
    }
    
    private func setupVideoController() {
        guard let videoUrl = viewModel.getVideoUrl() else { return }
        self.asset = AVURLAsset(url: videoUrl)
        self.playerController = AVPlayerViewController()
        if let playerController = self.playerController {
            playerController.player = avPlayer
            playerController.player?.actionAtItemEnd = .none
            playerController.showsPlaybackControls = true
            self.addChild(playerController)
            self.videoPlaceHolderView.addSubview(playerController.view)
            playerController.view.frame = CGRect(x: 0, y: 0, width: self.videoPlaceHolderView.frame.size.width, height: self.videoPlaceHolderView.frame.size.height)
            playerController.player?.appliesMediaSelectionCriteriaAutomatically = false
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(self.playerItemDidReachEnd(notification:)),
                                                   name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                   object: playerController.player?.currentItem)
            playerController.player?.play()
        }
    }
    
    @objc
    private func playerItemDidReachEnd(notification: Notification) {
        let p: AVPlayerItem = notification.object as! AVPlayerItem
        p.seek(to: CMTime.zero, completionHandler: nil)
        avPlayer.pause()
    }
    
    // MARK: - Load asset
    func asynchronouslyLoadURLAsset(_ newAsset: AVURLAsset) {
        newAsset.loadValuesAsynchronously(forKeys: VideoDetailVC.assetKeysRequiredToPlay) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self,
                    let newAsset = self.asset else {
                        return
                }
                self.videoPlayerItem = VideoPlayerItem(asset: newAsset)
                self.videoPlayerItem?.delegate = self
            }
        }
    }
    
    class func controller(viewModel: VideoDetailViewModel) -> VideoDetailVC {
        let sb = UIStoryboard(name: "Main", bundle: .main)
        let vc = sb.instantiateViewController(withIdentifier: String(describing: self)) as! VideoDetailVC
        vc.viewModel = viewModel
        return vc
    }
}

extension VideoDetailVC: VideoPlayerProtocol {
    func playbackReadyToPlay() {
        
    }
    
    func playbackError() {
        
    }
}
