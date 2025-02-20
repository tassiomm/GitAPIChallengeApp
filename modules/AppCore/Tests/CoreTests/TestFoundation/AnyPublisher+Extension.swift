//
//  AnyPublisher+Extension.swift
//  AppCore
//
//  Created by Tassio Marques on 16/02/25.
//

import Combine

extension AnyPublisher {
    public static func mockResult(result: Result<Self.Output, Self.Failure>) -> Self {
        switch result {
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        case .success(let output):
            return Just(output)
                .setFailureType(to: Failure.self)
                .eraseToAnyPublisher()
        }
    }
}
