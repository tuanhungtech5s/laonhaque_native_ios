//
//  Feed.swift
//  VillageMan
//
//  Created by cauca on 11/5/21.
//

import Foundation

let dateFormater: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    formatter.timeZone = TimeZone(secondsFromGMT: 7)
    return formatter
}()

let jsonDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(dateFormater)
    return decoder
}()

// MARK: - Item
struct Feed: Codable {
    let id: String
    let name: String
    let img: String
    let createTime: String
    let categoryValue: String?
    let isVideo: String?
    let video: String?
    let videoMp4: String?
    let link: String?
    
    var category: String { categoryValue ?? "Chung" }
    
    enum CodingKeys: String, CodingKey {
        case id, name, img
        case createTime = "create_time"
        case isVideo = "is_video"
        case categoryValue = "category"
        case video
        case videoMp4 = "video_mp4"
        case link
    }
}

extension Feed: Equatable, Comparable, Hashable, Identifiable {
    
    static func == (lsh: Feed, rhs: Feed) -> Bool {
        return lsh.id == rhs.id
    }
    
    static func < (lhs: Feed, rhs: Feed) -> Bool {
        return lhs.id < rhs.id
    }
    
}


struct FeedDetail: Codable {
    let id: String
    let name: String
    let img: String
    let createTime: String
    let categoryValue: String?
    let isVideo: String?
    let video: String?
    let content: String?
    let videoMp4: String?
    let link: String?
    
    var category: String { categoryValue ?? "Chung" }
    
    enum CodingKeys: String, CodingKey {
        case id, name, img
        case createTime = "create_time"
        case isVideo = "is_video"
        case categoryValue = "category"
        case videoMp4 = "video_mp4"
        case video, content, link
    }
}

extension FeedDetail: Equatable, Hashable, Identifiable {
    static func == (lsh: FeedDetail, rhs: FeedDetail) -> Bool {
        return lsh.id == rhs.id
    }
}

extension FeedDetail {
    var feed: Feed {
        .init(id: id,
              name: name,
              img: img,
              createTime: createTime,
              categoryValue: categoryValue,
              isVideo: isVideo,
              video: video,
              videoMp4: videoMp4,
              link: link)
    }
}

typealias Feeds = DataItems<Feed>

struct FeedResponse: Codable {
    let code: Int
    let categories: [Category]
    let feeds: Feeds
    let phone: String?
    
    enum CodingKeys: String, CodingKey {
        case code, categories
        case feeds
        case phone
    }
}

extension Feeds {
    static var example: Feeds {
        let jsonString = """
{
    "total": 245,
    "offset": 0,
    "limit": 10,
    "items": [
      {
        "id": "298",
        "name": "NÁM MẶT MỤN THỊT TRÊN MẮT VÀ MẶT",
        "img": "https://laonhaque.vn/uploads/nam-mat-mun-thit-tren-mat-va-mat.jpg",
        "create_time": "13/10/2021",
        "category": "Bệnh ngoài da"
      },
      {
        "id": "297",
        "name": "Dậm gót chân chữa đau gót chân, gai gót chân, tê nhức chân",
        "img": "https://laonhaque.vn/uploads/lao-nha-que-tham-lang-trao-yeu-thuong-1.jpg",
        "create_time": "10/10/2021",
        "category": "Tin bài Bác Hùng Y mới nhất",
        "is_video": "1"
      },
      {
        "id": "296",
        "name": "Bài tập xoay vai hỗ trợ điều trị các bệnh về cơ xương khớp.",
        "img": "https://laonhaque.vn/uploads/dam-got-chan-chua-dau-got-chan-gai-got-chan-te-nhuc-chan.png",
        "create_time": "30/09/2021",
        "category": "Vi Diệu Nam Dược"
      }
    ]
}
"""
        let emptyModel = Feeds(total: 0, offset: 0, limit: 0, items: [])
        guard let data = jsonString.data(using: .utf8) else {
            return emptyModel
        }
        do {
            return try jsonDecoder.decode(Feeds.self, from: data)
        } catch {
            debugPrint(error)
            return emptyModel
        }
    }
}
