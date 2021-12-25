//
//  Weather.swift
//  VillageMan
//
//  Created by cauca on 11/8/21.
//

import Foundation

struct Weather: Codable {
    let name, icon, temp, sunStart: String
    let sunEnd, feelsLike, humidity: String
    
    var humidityValue: Int {
        return Int(humidity) ?? 0
    }
    
    enum CodingKeys: String, CodingKey {
        case name, icon, temp
        case sunStart = "sun_start"
        case sunEnd = "sun_end"
        case feelsLike = "feels_like"
        case humidity
    }
}

extension Weather {
    static var example: Weather {
        return Weather(name: "Hanoi", icon: "03d",temp: "18", sunStart: "06:00:00", sunEnd: "18:00:00", feelsLike: "18", humidity: "70")
    }
}

extension Weather: Identifiable {
    var id: String { name }
}

struct Tools: Codable {
    let weathers: [Weather]
    let aqis: [AirQualityIndex]
    
    enum CodingKeys : String, CodingKey {
        case weathers
        case aqis
    }
}

extension Tools {
    static var example: Tools {
        return try! jsonDecoder.decode(Tools.self, from: toolsString.data(using: .utf8)!)
    }
}

let toolsString = """
{
  "code": 200,
  "weathers": [
    {
      "name": "Hanoi",
      "icon": "04n",
      "description": "overcast clouds",
      "temp": "21",
      "min_temp": "21",
      "max_temp": "21",
      "sun_start": "06:07:38",
      "sun_end": "17:15:22",
      "feels_like": "21",
      "humidity": "83"
    },
    {
      "name": "Ho Chi Minh City",
      "icon": "03n",
      "description": "scattered clouds",
      "temp": "26",
      "min_temp": "26",
      "max_temp": "26",
      "sun_start": "05:49:22",
      "sun_end": "17:27:01",
      "feels_like": "26",
      "humidity": "89"
    },
    {
      "name": "Nha Trang",
      "icon": "04n",
      "description": "overcast clouds",
      "temp": "25",
      "min_temp": "25",
      "max_temp": "25",
      "sun_start": "05:41:50",
      "sun_end": "17:14:49",
      "feels_like": "25",
      "humidity": "92"
    },
    {
      "name": "Haiphong",
      "icon": "04n",
      "description": "overcast clouds",
      "temp": "22",
      "min_temp": "22",
      "max_temp": "22",
      "sun_start": "06:04:37",
      "sun_end": "17:12:02",
      "feels_like": "23",
      "humidity": "88"
    },
    {
      "name": "Hue",
      "icon": "04n",
      "description": "broken clouds",
      "temp": "25",
      "min_temp": "25",
      "max_temp": "25",
      "sun_start": "05:54:17",
      "sun_end": "17:15:02",
      "feels_like": "26",
      "humidity": "94"
    },
    {
      "name": "Thanh Hoa",
      "icon": "04n",
      "description": "overcast clouds",
      "temp": "21",
      "min_temp": "21",
      "max_temp": "21",
      "sun_start": "06:06:39",
      "sun_end": "17:17:20",
      "feels_like": "22",
      "humidity": "92"
    },
    {
      "name": "Da Lat",
      "icon": "04n",
      "description": "overcast clouds",
      "temp": "15",
      "min_temp": "15",
      "max_temp": "15",
      "sun_start": "05:44:22",
      "sun_end": "17:18:13",
      "feels_like": "15",
      "humidity": "98"
    },
    {
      "name": "Bac Ninh",
      "icon": "04n",
      "description": "overcast clouds",
      "temp": "21",
      "min_temp": "21",
      "max_temp": "21",
      "sun_start": "06:07:40",
      "sun_end": "17:14:03",
      "feels_like": "21",
      "humidity": "81"
    }
  ],
  "aqis": [
    {
      "name": "Ha Noi",
      "code": "hanoi",
      "aqi": "185"
    },
    {
      "name": "Da Nang",
      "code": "da-nang",
      "aqi": "11"
    },
    {
      "name": "TP Ho Chi Minh",
      "code": "ho-chi-minh-city",
      "aqi": "46"
    },
    {
      "name": "Quang Ninh",
      "code": "ha-long",
      "aqi": "55"
    },
    {
      "name": "Bac Ninh",
      "code": "bac-ninh",
      "aqi": "211"
    },
    {
      "name": "Thai Nguyen",
      "code": "thai-nguyen",
      "aqi": "158"
    },
    {
      "name": "Phu Tho",
      "code": "viet-tri",
      "aqi": "-"
    },
    {
      "name": "Gia Lai",
      "code": "gia-lai",
      "aqi": "27"
    }
  ]
}
"""
