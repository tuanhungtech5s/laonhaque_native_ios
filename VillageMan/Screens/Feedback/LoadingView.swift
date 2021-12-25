//
//  LoadingView.swift
//  VillageMan
//
//  Created by cauca on 11/12/21.
//

import SwiftUI

struct LoadingView: View {
    
    var loading: Bool = true
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                
                if loading {
                    ActivityIndicatorView()
                } else {
                    LottieView(name: "success-tick")
                        .frame(width: 80, height: 80, alignment: .center)
                }
                
                Spacer()
            }
            Text(self.loading ? "Đang gửi..." : "Thành công!")
                .font(.title).bold()
            Spacer()
        }
        
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
