//
//  Apollo.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 9/28/24.
//

import Apollo
import ApolloAPI
import Foundation

// AuthorizationInterceptor to add the Authorization header
class AuthorizationInterceptor: ApolloInterceptor {
    public var id: String = UUID().uuidString

    func interceptAsync<Operation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void
    ) where Operation: GraphQLOperation {
        Task {
            if let accessToken = await Database.client.auth.session?.accessToken {
                request.addHeader(name: "Authorization", value: "Bearer \(accessToken)")
            }

            chain.proceedAsync(request: request, response: response, interceptor: self, completion: completion)
        }
    }
}

// NetworkInterceptorProvider to insert AuthorizationInterceptor
class NetworkInterceptorProvider: DefaultInterceptorProvider {
    let store: ApolloStore

    init(store: ApolloStore, client: URLSessionClient) {
        self.store = store
        super.init(store: store, client: client)
    }

    override func interceptors<Operation>(for operation: Operation) -> [ApolloInterceptor] where Operation: GraphQLOperation {
        var interceptors = super.interceptors(for: operation)
        interceptors.insert(AuthorizationInterceptor(), at: 0) // Insert at the beginning
        return interceptors
    }
}
