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
                guard let accessToken = Database.client.auth.currentSession?.accessToken else {
                    fatalError("NO ACCESS TOKEN FOR GQL")
                }
                guard let supabaseKey = Bundle.main.infoDictionary?["SUPABASE_KEY"] as? String else {
                    fatalError("SUPABASE_KEY in Info.plist is missing!")
                }
                request.addHeader(name: "Authorization", value: "Bearer \(accessToken)")
                request.addHeader(name: "apiKey", value: supabaseKey)
                chain.proceedAsync(request: request, response: response, interceptor: self, completion: completion)
            }
        }
    }
}

// NetworkInterceptorProvider to insert AuthorizationInterceptor
class NetworkInterceptorProvider: InterceptorProvider {
    let store: ApolloStore

    private let client: URLSessionClient

    init(store: ApolloStore, client: URLSessionClient) {
        self.store = store
        self.client = client
    }

    func interceptors<Operation: GraphQLOperation>(for operation: Operation) -> [ApolloInterceptor] {
        return [
            AuthorizationInterceptor(),
            MaxRetryInterceptor(),
//            CacheReadInterceptor(store: store),
            NetworkFetchInterceptor(client: client),
            ResponseCodeInterceptor(),
            JSONResponseParsingInterceptor(),
            AutomaticPersistedQueryInterceptor(),
//            CacheWriteInterceptor(store: store)
        ]
    }
}

class Network {
    static let shared = Network()

    private(set) lazy var apollo: ApolloClient = {
        let client = URLSessionClient()
        let cache = InMemoryNormalizedCache()
        let store = ApolloStore(cache: cache)
        let provider = NetworkInterceptorProvider(store: store, client: client)
        guard let supabaseUrlString = Bundle.main.infoDictionary?["SUPABASE_URL"] as? String
        else {
            fatalError("Missing SUPABASE_URL for Graphql URL")
        }
        let url = URL(string: "\(supabaseUrlString)/graphql/v1")
        let transport = RequestChainNetworkTransport(interceptorProvider: provider, endpointURL: url!)

        return ApolloClient(networkTransport: transport, store: store)
    }()
}
