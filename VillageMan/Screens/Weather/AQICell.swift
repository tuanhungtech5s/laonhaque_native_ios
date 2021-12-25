//
//  AQICell.swift
//  VillageMan
//
//  Created by cauca on 11/17/21.
//

import SwiftUI

struct AQICell: View {
    
    let model: AirQualityIndex
   
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text(model.name)
                    .foregroundColor(.white)
                    .padding(4)
                    .font(.robotoTitle)
                Spacer()
            }.background(Color(hex: "#007766"))
            AirQuanlityView(aqi: model.aqi)
        }.padding(4)
        .background(RoundedRectangle(cornerRadius: 12).foregroundColor(.mainColor))
            
        
    }
}

struct AQICell_Previews: PreviewProvider {
    static var previews: some View {
        AQICell(model: .example)
    }
}
