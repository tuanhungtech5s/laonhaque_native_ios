//
//  Trends.swift
//  VillageMan
//
//  Created by cauca on 11/5/21.
//

import Foundation

struct Trend: Codable {
    let title: String
    let items: [Feed]
}

extension Trend: Identifiable {
    var id: String { title }
}

struct Trends: Codable {
    let latest: Trend?
    let most: Trend?
    let hot: Trend?
    let phone: String?
}

extension Trends {
    var items: [Trend] {
        [latest, most, hot].compactMap({ $0 }).filter({ $0.items.count > 0 })
    }
}

extension Trends {
    static var example: Trends {
        let jsonString = """
{
"latest": {
  "title": "Tin tức mới nhất",
  "type": "LATEST",
  "icon": "star",
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
      "name": "“Lão nhà quê” thầm lặng trao yêu thương",
      "img": "https://laonhaque.vn/uploads/lao-nha-que-tham-lang-trao-yeu-thuong-1.jpg",
      "create_time": "10/10/2021",
      "category": "Tin bài Bác Hùng Y mới nhất"
    },
    {
      "id": "296",
      "name": "Dậm gót chân chữa đau gót chân, gai gót chân, tê nhức chân",
      "img": "https://laonhaque.vn/uploads/dam-got-chan-chua-dau-got-chan-gai-got-chan-te-nhuc-chan.png",
      "create_time": "30/09/2021",
      "category": "Vi Diệu Nam Dược"
    }
  ]
},
"most": {
  "title": "Tin tức xem nhiều",
  "type": "MOST",
  "items": [
    {
      "id": "33",
      "name": "VIÊM GAN B, GAN C",
      "img": "https://laonhaque.vn/uploads/news/cac-benh-tieu-hoa/viem-gan.jpg",
      "create_time": "23/09/2018",
      "category": "Các bệnh tiêu hóa"
    },
    {
      "id": "78",
      "name": "Gửi các mẹ mong con",
      "img": "https://laonhaque.vn/uploads/news/hiem-muon/mong-con.jpg",
      "create_time": "23/09/2018",
      "category": "Hiếm muộn"
    },
    {
      "id": "36",
      "name": "BÀI THUỐC VỚI GỪNG",
      "img": "https://laonhaque.vn/uploads/news/cac-benh-tieu-hoa/1-bai-thuoc-voi-gung.jpg",
      "create_time": "19/09/2018",
      "category": "Các bệnh tiêu hóa"
    }
  ]
},
"hot": {
  "title": "Tin tức nổi bật",
  "type": "HOT",
  "icon": "bulb",
  "items": [
    {
      "id": "298",
      "name": "NÁM MẶT MỤN THỊT TRÊN MẮT VÀ MẶT",
      "img": "https://laonhaque.vn/uploads/nam-mat-mun-thit-tren-mat-va-mat.jpg",
      "create_time": "13/10/2021",
      "category": "Bệnh ngoài da"
    },
    {
      "id": "293",
      "name": "HÃY TỬ TẾ, ĐỂ CHO KIẾP SAU",
      "img": "https://laonhaque.vn/uploads/hay-tu-te-de-cho-kiep-sau-1.jpg",
      "create_time": "15/09/2021",
      "category": "Tâm Linh"
    },
    {
      "id": "291",
      "name": "Bài tập xoay vai hỗ trợ điều trị các bệnh về cơ xương khớp.",
      "img": "https://laonhaque.vn/uploads/bai-tap-xoay-vai-ho-tro-dieu-tri-benh-xuong-khop.png",
      "create_time": "10/09/2021",
      "category": "Tin bài Bác Hùng Y mới nhất"
    }
  ]
}
}
"""
        return try! jsonDecoder.decode(Trends.self, from: jsonString.data(using: .utf8)!)
    }
}
