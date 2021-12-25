//
//  AirQualityIndex.swift
//  VillageMan
//
//  Created by cauca on 11/17/21.
//

import Foundation

struct AirQualityIndex {
    let name: String
    let code: String
    let aqi: Int
}

extension AirQualityIndex: Codable, Identifiable {
    
    enum CodingKeys: String, CodingKey {
        case name
        case code
        case aqi
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.code = try container.decode(String.self, forKey: .code)
        self.aqi = Int(try container.decode(String.self, forKey: .aqi)) ?? 0
    }
    
    var id: String { code }
}

extension AirQualityIndex {
    static var example: AirQualityIndex {
        .init(name: "Ha Noi", code: "ha-noi", aqi: 30)
    }
}
