//
//  MainView.swift
//  VillageMan
//
//  Created by cauca on 11/5/21.
//

import SwiftUI

struct MainView: View {
    let service = RealService()
    var body: some View {
        TabView {
            TrendFeedsView(viewModel: .init(service: service)).tabItem {
                VStack {
                    Image(systemName: "flame")
                    Text("Nổi bật")
                }
            }
            NewsView(viewModel: .init(service: service)).tabItem {
                VStack {
                    Image(systemName: "newspaper")
                    Text("Tin tức")
                }
            }
            VideoView(viewModel: .init(service: service)).tabItem {
                VStack {
                    Image(systemName: "video")
                    Text("Video")
                }
            }
            WeatherView(viewModel: .init(service: service)).tabItem {
                VStack {
                    Image(systemName: "cloud.sun")
                    Text("Tiện ích")
                }
            }
        }.navigationViewStyle(.stack)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
