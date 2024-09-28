//
//  ApolloClient.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 9/28/24.
//

import Apollo

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

// ApolloClient setup

let gqlClient: ApolloClient = {
    let cache = InMemoryNormalizedCache()
    let store = ApolloStore(cache: cache)

    let sessionClient = URLSessionClient()
    let networkInterceptorProvider = NetworkInterceptorProvider(store: store, client: sessionClient)

    let networkTransport = RequestChainNetworkTransport(
        interceptorProvider: networkInterceptorProvider,
        endpointURL: URL(string: "http://127.0.0.1:54321/graphql/v1")!
    )

    return ApolloClient(networkTransport: networkTransport, store: store)
}()
