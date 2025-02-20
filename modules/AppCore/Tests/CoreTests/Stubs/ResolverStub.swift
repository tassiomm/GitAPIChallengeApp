//
//  ResolverStub.swift
//  AppCore
//
//  Created by Tassio Marques on 16/02/25.
//

import DependencyInjection

struct ResolverStub: Resolver {
    let result: () -> Any
    
    func resolve<T>(_ metaType: T.Type) -> T? {
        guard let result = result() as? T else {
            fatalError("Expects result of stub to be of the same type")
        }
        return result
    }
    
    func autoResolve<T>() -> T? {
        guard let result = result() as? T else {
            fatalError("Expects result of stub to be of the same type")
        }
        return result
    }
}
