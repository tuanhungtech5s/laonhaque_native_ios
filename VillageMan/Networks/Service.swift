//
//  Service.swift
//  VillageMan
//
//  Created by cauca on 11/6/21.
//

import Foundation
import Combine

enum APIAction {
    case load(router: String, offset: Int)
    case detail(router: String, id: String)
    case post(router: String, bodyData: Data?)
    case search(keyword: String)
}

enum APIError: Swift.Error {
    case invalidURL
    case httpCode(HTTPCode)
    case unexpectedResponse
    case imageProcessing([URLRequest])
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case let .httpCode(code): return "Unexpected HTTP code: \(code)"
        case .unexpectedResponse: return "Unexpected response from the server"
        case .imageProcessing: return "Unable to load image"
        }
    }
}

typealias HTTPCode = Int
typealias HTTPCodes = Range<HTTPCode>

extension HTTPCodes {
    static let success = 200 ..< 300
}

struct ApiMessage: Codable {
    let code: Int
    let message: String
}

protocol Service {
    func trends(offset: Int) -> AnyPublisher<Trends, Error>
    func detail(id: String) -> AnyPublisher<DetailItems<FeedDetail, Feed>, Error>
    func feeds(offset: Int) -> AnyPublisher<FeedResponse, Error>
    func news(byCategory: String, offset: Int) -> AnyPublisher<DetailItem<DataItems<Feed>>, Error>
    func video(offset: Int) -> AnyPublisher<FeedResponse, Error>
    func tools() -> AnyPublisher<Tools, Error>
    func feedback(model: Feedback) -> AnyPublisher<ApiMessage, Error>
    func search(keyword: String) -> AnyPublisher<DetailItem<DataItems<Feed>>, Error>
}

struct RealService {
    private let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        configuration.waitsForConnectivity = true
        configuration.httpMaximumConnectionsPerHost = 5
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.urlCache = .shared
        return URLSession(configuration: configuration)
    }()
    
    private let collection = RMCollection<RMResponseCache>()
    
    private let baseURL = "https://laonhaque.vn/api/Api"
    private let queue = DispatchQueue(label: "bg_parse_queue")
    
    func call<Model>(_ action: APIAction) -> AnyPublisher<Model, Error> where Model: Codable {
        let urlString: String
        var data: Data?
        
        switch action {
        case .load(let router, let offset):
            urlString = "\(baseURL)/\(router)?order=latest&limit=20&offset=\(offset)"
        case .detail(let router, let id):
            urlString = "\(baseURL)/\(router)/\(id)"
        case .post(let router, let bodyData):
            urlString = "\(baseURL)/\(router)"
            data = bodyData
        case .search(let keyword):
            urlString = "\(baseURL)/search?q=\(keyword)"
        }
        guard let url = URL(string: urlString) else {
            return Fail<Model, Error>(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 120)
        if let body = data {
            request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = body
            request.httpMethod = "POST"
        }
        
        let method = request.httpMethod ?? "GET"
        let cacheData = self.collection.model(urlString)?.data
        let cache = Just.withErrorType(cacheData, Error.self).compactMap({ $0 }).eraseToAnyPublisher()
        
        let task = session.dataTaskPublisher(for: request)
            .handleEvents(receiveOutput: { (data, _) in
                guard method == "GET" else { return }
                let model = RMResponseCache(key: urlString, data: data)
                self.collection.add(model)
            })
            .map({ $0.data })
            .catch({ error -> AnyPublisher<Data, Error> in
                guard error.code == .notConnectedToInternet,
                      let data = self.collection.model(urlString)?.data else {
                          return Fail(error: error).eraseToAnyPublisher()
                      }
                return Just<Data>(data)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            })
        return cache.merge(with: task)
            .decode(type: Model.self, decoder: jsonDecoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

extension RealService: Service {
    
    func feeds(offset: Int) -> AnyPublisher<FeedResponse, Error> {
        return call(.load(router: "home", offset: offset))
    }
    
    func detail(id: String) -> AnyPublisher<DetailItems<FeedDetail, Feed>, Error> {
        return call(.detail(router: "news", id: id))
    }
    
    func trends(offset: Int) -> AnyPublisher<Trends, Error> {
        return call(.load(router: "trends", offset: offset))
    }
    
    func news(byCategory: String, offset: Int) -> AnyPublisher<DetailItem<DataItems<Feed>>, Error> {
        return call(.load(router: "getNewsBycategories/\(byCategory)", offset: offset))
    }
    
    func video(offset: Int) -> AnyPublisher<FeedResponse, Error> {
        return call(.load(router: "video", offset: offset))
    }
    
    func tools() -> AnyPublisher<Tools, Error> {
        return call(.load(router: "tools", offset: 0))
    }
    
    func feedback(model: Feedback) -> AnyPublisher<ApiMessage, Error> {
        do {
            let data = try JSONEncoder().encode(model)
            return call(.post(router: "contact", bodyData: data))
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    func search(keyword: String) -> AnyPublisher<DetailItem<DataItems<Feed>>, Error> {
        return call(.search(keyword: keyword))
    }
}
