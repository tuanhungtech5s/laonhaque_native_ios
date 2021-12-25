//
//  ServiceMock.swift
//  VillageMan
//
//  Created by cauca on 11/6/21.
//

import Foundation
import Combine

struct ServiceMock {
    
}

extension ServiceMock: Service {

    func trends(offset: Int) -> AnyPublisher<Trends, Error> {
        return Result.Publisher(.success(Trends.example)).eraseToAnyPublisher()
    }
    
    func detail(id: String) -> AnyPublisher<DetailItems<FeedDetail, Feed>, Error> {
        return Empty().eraseToAnyPublisher()
    }
    
    func feeds(offset: Int) -> AnyPublisher<FeedResponse, Error> {
        return Empty().eraseToAnyPublisher()
    }
    
    func news(byCategory: String, offset: Int) -> AnyPublisher<DetailItem<DataItems<Feed>>, Error> {
        return Empty().eraseToAnyPublisher()
    }
    
    func video(offset: Int) -> AnyPublisher<FeedResponse, Error> {
        return Empty().eraseToAnyPublisher()
    }
    
    func tools() -> AnyPublisher<Tools, Error> {
        return Just(Tools.example).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func feedback(model: Feedback) -> AnyPublisher<ApiMessage, Error> {
        return Empty().eraseToAnyPublisher()
    }
    
    func search(keyword: String) -> AnyPublisher<DetailItem<DataItems<Feed>>, Error> {
        return Empty().eraseToAnyPublisher()
    }
    
}
