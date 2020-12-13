//
//  WebserviceManager.swift
//  VideoPlayerOfflineDownload
//
//  Created by Niraj Kumar Jha on 13/12/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import Foundation

public enum HttpMethodType {
    case get
    case post([String: Any])
}

public extension HttpMethodType {
    var type: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        }
    }
}

public struct Resource<R> {
    public let url: URL
    public let method: HttpMethodType
    public let parse: (Data) -> R?
}

public extension Resource {
    init(url: URL,  parseJSON: @escaping (Any) -> R?, method: HttpMethodType = .get) {
        self.url = url
        self.method = method
        self.parse = { data in
            let json = try? JSONSerialization.jsonObject(with: data as Data , options: JSONSerialization.ReadingOptions())
            return json.flatMap(parseJSON)
        }
    }
}

public extension NSMutableURLRequest {
    convenience init<R>(resource: Resource<R>) {
        self.init(url: resource.url)
        httpMethod = resource.method.type
        if case let .post(json) = resource.method  {
            if let bodyData = try? JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions()) {
                httpBody = bodyData
            }
        }
    }
}


public var defaultSession:URLSessionProtocol = URLSession(configuration: configuration)

public protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}
extension URLSession: URLSessionProtocol { }

public let configuration: URLSessionConfiguration = {
    var configuration: URLSessionConfiguration = .default
    configuration.httpCookieAcceptPolicy = .always
    return configuration
}()


public class WebServiceManager {
    public var dataTask: URLSessionTask? = nil
    
    public init() {}
    
    public func load<A>(resource: Resource<A>, completion: @escaping (A?, Error?) -> ()) {
        let request = NSMutableURLRequest(resource: resource)
        dataTask = defaultSession.dataTask(with: request as URLRequest) { data, response, error in
            
            guard let data = data else {
                completion(nil, error)
                return
            }
            
            completion(resource.parse(data), error)
        }
        dataTask?.resume()
    }
    
    public func cancelTask(){
        self.dataTask?.cancel()
        self.dataTask = nil
    }
}

