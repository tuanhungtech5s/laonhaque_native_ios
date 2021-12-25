//
//  Category.swift
//  VillageMan
//
//  Created by cauca on 11/5/21.
//

import Foundation

// MARK: - Category
struct Category: Codable {
    let id, name: String
}

extension Category: Identifiable { }
extension Category {
    static var items: [Category] {
        let jsonString = """
[{"id":"1","name":"Bệnh ngoài da"},{"id":"2","name":"Các bệnh tiêu hóa"},{"id":"3","name":"Các bệnh về Phổi"},{"id":"4","name":"Chuyên khoa"},{"id":"5","name":"Hiếm muộn"}]
"""
        guard let data = jsonString.data(using: .utf8),
              let items = try? jsonDecoder.decode([Category].self, from: data) else { return [] }
        return items
    }
}
