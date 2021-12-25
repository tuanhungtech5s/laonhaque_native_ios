//
//  ErrorView.swift
//  VillageMan
//
//  Created by cauca on 11/10/21.
//

import SwiftUI

struct ErrorView: View {
    
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .center, spacing: 0) {
                Label("Có lỗi xảy ra", systemImage: "cloud.rain").foregroundColor(.gray)
                    .font(.largeTitle)
                Text("Bấm để tải lại ")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(EdgeInsets.init(top: 8, leading: 24, bottom: 8, trailing: 24))
                    .background(RoundedRectangle(cornerRadius: 22).foregroundColor(.mainColor))
            }.shadow(color: .gray, radius: 2, x: 4, y: 4)
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(action: { })
    }
}
