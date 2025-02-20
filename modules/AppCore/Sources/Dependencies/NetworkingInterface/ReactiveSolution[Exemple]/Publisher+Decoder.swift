//
//  File.swift
//  AppCore
//
//  Created by Tassio Marques on 19/02/25.
//

import Foundation
import Combine

extension Publisher {
    /// Attemps to decode a data type via publisher. Will return the decoded data or decoding error if it fails
    /// - Parameters:
    ///   - decoder: A  DataDecoder describing how to decode the data
    ///   - type: the result type of a successfull decoding
    /// - Returns: a publisher with the result of the decoding or an error if decoding fails
    public func decode<Item>(decoder: DataDecoder, type: Item.Type) -> AnyPublisher<Item, Error> where Item : Decodable, Self.Output == Data {
        tryMap { data -> Item in
            try decoder.decode(type, from: data)
        }.eraseToAnyPublisher()
    }
}
