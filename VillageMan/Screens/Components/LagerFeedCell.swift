//
//  LagerFeedCell.swift
//  VillageMan
//
//  Created by cauca on 11/5/21.
//

import SwiftUI
import Kingfisher
import AVKit

struct LagerFeedCell: View {
    
    let model: Feed
    let canNavigate: Bool
    
    init(model: Feed, canNavigate: Bool = true) {
        self.model = model
        self.canNavigate = canNavigate
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            ZStack {
                if canNavigate {
                    NavigationLink {
                        if let videoMp4 = model.videoMp4, let url = URL(string: videoMp4) {
                            let player = AVPlayer(url: url)
                            AVVideoView(player: player).onDisappear {
                                player.pause()
                            }
                        } else if let video = model.video {
                            VideoPlayerView(youtubeUrl: video)
                        } else {
                            FeedDetailView(service: RealService(), model: model)
                        }
                    } label: {
                        EmptyView()
                    }.opacity(0)

                }
                KFImage.url(URL(string: model.img))
                    .placeholder {
                        ActivityIndicatorView()
                            .frame(width: 120, height: 120, alignment: .center)
                    }
                    .resizable()
                    .cornerRadius(10)
                    .frame(minHeight: 80, idealHeight: 240, maxHeight: 800, alignment: .topLeading)
                if let isVideo = self.model.isVideo, isVideo == "1" {
                    Image(systemName: "play")
                        .font(.title)
                        .foregroundColor(.mainColor)
                        .padding(EdgeInsets.init(top: 8, leading: 8, bottom: 8, trailing: 8))
                        .background(RoundedRectangle(cornerRadius: 25).foregroundColor(.white.opacity(0.8)))
                        .frame(width: 70, height: 70, alignment: .center)
                        
                }
            }
            
            Text(model.name)
                .font(.robotoTitle)
            
            HStack(alignment: .center, spacing: 20) {
                Text(model.category)
                    .font(.robotoTitleText)
                    .foregroundColor(.white)
                    .padding(EdgeInsets.init(top: 5, leading: 10, bottom: 5, trailing: 10))
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.mainColor))
                Text(model.createTime)
                    .font(.robotoTitleText)
                    .foregroundColor(.gray)
            }
            if let link = model.link, let url = URL(string: link), let host = url.host {
                Text("Nguồn: \(host)")
                    .font(.robotoCaption)
                    .padding(3)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color.green).opacity(0.8)
                            .opacity(0.3)
                    )
                    
            }
        }.frame(minHeight: 240, idealHeight: 320, maxHeight: 480, alignment: .top)
    }
}

struct LagerFeedView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            Section(header: Text("Header").font(Font.largeTitle)) {
                ForEach(Feeds.example.items) { feed in
                    LagerFeedCell(model: feed)
                }
            }
        }
        .listStyle(.grouped)
        .previewLayout(.device)
    }
}
