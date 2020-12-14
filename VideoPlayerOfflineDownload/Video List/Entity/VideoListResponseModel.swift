//
//  VideoListResponseModel.swift
//  VideoPlayerOfflineDownload
//
//  Created by Niraj Kumar Jha on 13/12/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import Foundation

typealias VideoListResponseModel = [VideoModel]

struct VideoModel: Codable {
    let id: String
    let title: String?
    let video: String?
}
