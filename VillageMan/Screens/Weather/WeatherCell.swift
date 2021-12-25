//
//  WeatherCell.swift
//  VillageMan
//
//  Created by cauca on 11/8/21.
//

import SwiftUI
import Kingfisher

struct WeatherCell: View {
    
    let model: Weather
    let aiq: Int?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(model.name)
                    .foregroundColor(Color.white)
                    .font(Font.robotoLagerTitle)
                Spacer()
                KFImage(URL(string: "https://openweathermap.org/img/wn/\(model.icon).png"))
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(height: 40, alignment: .top)
            }
            HStack {
                HStack(alignment: .top, spacing: 1) {
                    Text("\(model.temp)")
                        .foregroundColor(Color.white)
                        .font(Font.system(size: 60, weight: .medium, design: .default))
                    Image(systemName: "circle")
                        .foregroundColor(Color.white)
                        .font(Font.system(size: 20, weight: .black, design: .default))
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 8) {
                    HStack(alignment: .bottom, spacing: 0) {
                        Image(systemName: "humidity")
                            .foregroundColor(Color.white)
                            .font(Font.system(size: 17, weight: .black, design: .default))
                        Text(" \(model.humidity)% ~ \(model.feelsLike)")
                            .font(Font.robotoTitle)
                            .foregroundColor(Color.white)
                        
                        Image(systemName: "circle")
                            .foregroundColor(Color.white)
                            .font(Font.system(size: 8, weight: .black, design: .default)).padding([.bottom], 10)
                        
                    }
                    HStack(alignment: .bottom, spacing: 5) {
                        Image(systemName: "sunrise")
                            .foregroundColor(Color.white)
                            .font(Font.system(size: 20, weight: .black, design: .default))
                        Text(model.sunStart)
                            .foregroundColor(Color.white)
                        Image(systemName: "sunset")
                            .foregroundColor(Color.white)
                            .font(Font.system(size: 20, weight: .black, design: .default))
                        Text(model.sunStart)
                            .foregroundColor(Color.white)
                    }
                }
            }
            if let aiq = aiq {
                AirQuanlityView(aqi: aiq)
            }
            
        }
        .padding(8)
        .background(RoundedRectangle(cornerRadius: 16).foregroundColor(.mainColor))
    }
}

struct WeatherCell_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            WeatherCell(model: .example, aiq: 50)
            Spacer()
        }
        .previewLayout(.device).background(
            Color.black
        )
    }
}
