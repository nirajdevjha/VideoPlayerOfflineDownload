//
//  VideoPlayerItem.swift
//  VideoPlayerOfflineDownload
//
//  Created by Niraj Kumar Jha on 13/12/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import Foundation
import AVFoundation

protocol VideoPlayerProtocol: class {
    func playbackReadyToPlay()
    func playbackError()
}

class VideoPlayerItem: AVPlayerItem {
    
    weak var delegate: VideoPlayerProtocol?
    private var playerItemContext = 0

    init(url: URL) {
        super.init(asset: AVAsset(url: url), automaticallyLoadedAssetKeys: [])
        self.addObservers()
    }
    
    init(asset: AVAsset) {
        super.init(asset:asset, automaticallyLoadedAssetKeys: [])
        self.addObservers()
    }
    
    deinit {
        self.removeObservers()
    }
    
    func addObservers() {
        self.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: &playerItemContext)
    }
    
    func removeObservers() {
       self.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), context: &playerItemContext)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard context == &playerItemContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItem.Status
            
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            switch status {
            case .readyToPlay:
                delegate?.playbackReadyToPlay()
                break
            case .failed:
                delegate?.playbackError()
                break
            case .unknown:
                delegate?.playbackError()
                break
            default:
                break
            }
        }
    }
}

