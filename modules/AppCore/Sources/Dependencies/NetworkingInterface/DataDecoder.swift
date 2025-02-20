//
//  DataDecoder.swift
//  AppCore
//
//  Created by Tassio Marques on 14/02/25.
//

import Foundation
import Combine

/// A interface for decoding Data
public protocol DataDecoder {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}

extension JSONDecoder: DataDecoder {}


