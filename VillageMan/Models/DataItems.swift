//
//  DataItems.swift
//  VillageMan
//
//  Created by cauca on 11/5/21.
//

import Foundation

struct DetailItems<Item: Codable, Relate: Codable>: Codable {
    let items: [Item]
    let relatedNews: [Relate]
}

struct DetailItem<Item: Codable>: Codable {
    let items: Item
}

struct DataItems<Item: Codable>: Codable {
    let total: Int
    let offset: Int
    let limit: Int
    let items: [Item]
}
