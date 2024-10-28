//
//  Network.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 9/28/24.
//
import Apollo
import ApolloAPI
import ApolloGQL
import Foundation

class AuthorizationInterceptor: ApolloInterceptor {
    public var id: String = UUID().uuidString

    func interceptAsync<Operation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void
    ) where Operation: GraphQLOperation {
        Task {
            do {
                let accessToken = try await Database.client.auth.session.accessToken
                request.addHeader(name: "Authorization", value: "Bearer \(accessToken)")
                chain.proceedAsync(request: request, response: response, interceptor: self, completion: completion)
            } catch {
                completion(.failure(error))
            }
        }
    }
}

// NetworkInterceptorProvider to insert AuthorizationInterceptor
class NetworkInterceptorProvider: DefaultInterceptorProvider {
    let store: ApolloStore

    init(store: ApolloStore, client: URLSessionClient) {
        self.store = store
        super.init(client: client, store: store)
    }

    override func interceptors<Operation>(for operation: Operation) -> [ApolloInterceptor] where Operation: GraphQLOperation {
        var interceptors = super.interceptors(for: operation)
        interceptors.insert(AuthorizationInterceptor(), at: 0) // Insert at the beginning
        return interceptors
    }
}

class Network {
    static let shared = Network()

    private(set) lazy var apollo: ApolloClient = {
        let client = URLSessionClient()
        let cache = InMemoryNormalizedCache()
        let store = ApolloStore(cache: cache)
        let provider = NetworkInterceptorProvider(store: store, client: client)
        let url = URL(string: "http://127.0.0.1:54321/graphql/v1")!
        let transport = RequestChainNetworkTransport(interceptorProvider: provider, endpointURL: url)

        return ApolloClient(networkTransport: transport, store: store)
    }()
}
