//
//  Network.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 9/28/24.
//
import Apollo
import ApolloAPI
import ApolloGQL
import ApolloSQLite
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
                guard let supabaseKey = GlobalSettings.apiServiceKey else {
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

    func interceptors<Operation: GraphQLOperation>(for _: Operation) -> [ApolloInterceptor] {
        return [
            AuthorizationInterceptor(),
            MaxRetryInterceptor(),
            CacheReadInterceptor(store: store),
            NetworkFetchInterceptor(client: client),
            ResponseCodeInterceptor(),
            JSONResponseParsingInterceptor(),
            AutomaticPersistedQueryInterceptor(),
            CacheWriteInterceptor(store: store)
        ]
    }
}

class Network {
    static let shared = Network()

    private(set) lazy var apollo: ApolloClient = {
        let client = URLSessionClient()

        let store: ApolloStore
        do {
            let fileURL = FileManager.default
                .urls(for: .cachesDirectory, in: .userDomainMask)
                .first!
                .appendingPathComponent("apollo.sqlite")

            let sqliteCache = try SQLiteNormalizedCache(fileURL: fileURL)
            store = ApolloStore(cache: sqliteCache)
        } catch {
            print("⚠️ Failed to initialize SQLiteNormalizedCache. Falling back to in-memory cache: \(error)")
            store = ApolloStore(cache: InMemoryNormalizedCache())
        }

        guard let supabaseUrlString = GlobalSettings.baseApiUrl,
              let endpointURL = URL(string: "\(supabaseUrlString)/graphql/v1")
        else {
            fatalError("❌ Missing or invalid Supabase GraphQL URL.")
        }

        let provider = NetworkInterceptorProvider(store: store, client: client)
        let transport = RequestChainNetworkTransport(interceptorProvider: provider, endpointURL: endpointURL)

        return ApolloClient(networkTransport: transport, store: store)
    }()
}
