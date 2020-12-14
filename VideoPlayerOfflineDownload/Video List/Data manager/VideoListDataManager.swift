//
//  VideoListDataManager.swift
//  VideoPlayerOfflineDownload
//
//  Created by Niraj Kumar Jha on 13/12/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import Foundation

enum VideoListAPIError: Error {
    case failed(error: Error)
    case emptyResponse
    case failedWith(errorMessage: String, errorCode: String)
}

class VideoListDataManager: VideoListDataManagerProtocol {
    func fetchVideoListAPI(completion: @escaping (Result<VideoListResponseModel, VideoListAPIError>) -> Void) {
        
        guard let resource = buildVideoListResource() else {
            return
        }
        WebServiceManager().load(resource: resource) { response, error in
            DispatchQueue.main.async { [weak self] in
                guard self != nil else { return }
                
                if let error = error {
                    completion(.failure(.failed(error: error)))
                    return
                }
                
                guard let response = response  else {
                    completion(.failure(.emptyResponse))
                    return
                }
                completion(.success(response))
            }
        }
    }
    
    func buildVideoListResource() -> Resource<VideoListResponseModel>? {
        let listUrl: String = "https://www.mocky.io/v2/5ec2a6b32f000086e3c354fb"
        guard let url = URL(string: listUrl) else { return nil }
        
        let resource = Resource<VideoListResponseModel>(url: url, parseJSON: { json in
            do {
                guard let jsonData = json as? [Any] else { return nil }
                let model = try EncoderDecoder().decode(VideoListResponseModel.self, from: jsonData)
                return model
            } catch let error {
                debugPrint("Parsing Error: \(error)")
                return nil
            }
        }, method: .get)
        return resource
    }
    
}
