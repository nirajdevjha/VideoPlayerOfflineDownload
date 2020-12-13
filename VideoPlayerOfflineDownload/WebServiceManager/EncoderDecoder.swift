//
//  EncoderDecoder.swift
//  VideoPlayerOfflineDownload
//
//  Created by Niraj Kumar Jha on 13/12/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import Foundation

public class EncoderDecoder {
    public let decoder = JSONDecoder()
    public let encoder = JSONEncoder()
    
    public init() {}
    
    public func decode<D>(_ type: D.Type, from data: Data) throws -> D where D: Decodable {
        return try self.decoder.decode(type, from: data)
    }
    
    public func decode<D>(_ type: D.Type, from dictionary: [String: Any]) throws -> D where D: Decodable {
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        return try self.decoder.decode(type, from: data)
    }
    
    public func decode<D>(_ type: D.Type, from array: [Any]) throws -> D where D: Decodable {
        let data = try JSONSerialization.data(withJSONObject: array, options: .prettyPrinted)
        return try self.decoder.decode(type, from: data)
    }
    
    public func encode<E>(_ value: E) throws -> Data where E: Encodable {
        return try self.encoder.encode(value)
    }
}

