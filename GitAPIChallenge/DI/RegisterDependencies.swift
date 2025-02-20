//
//  RegisterDependencies.swift
//  GitAPIChallenge
//
//  Created by Tassio Marques on 19/02/25.
//

import Foundation
import DependencyInjection
import NetworkingInterface
import Networking
import RepositoriesFeature
import RepositoriesAPI
import RepositoriesRepository
import RepositoriesAPIInterface
import RepositoriesRepositoryInterface

extension GitAPIChallengeApp {
    func registerAllDependencies() {
        let container = ServiceLocator.shared
        
        container.register(factory: { HTTPClient() }, forMetaType: NetworkClient.self)
        container.register(factory: { JSONDecoder() }, forMetaType: DataDecoder.self)
        container.register(factory: { RepositoriesDataSource() }, forMetaType: RepositoriesDataSourceProtocol.self)
        container.register(factory: { RepositoriesRepository() }, forMetaType: RepositoriesRepositoryProtocol.self)
    }
}
