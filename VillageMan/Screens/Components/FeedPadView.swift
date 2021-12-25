//
//  FeedPadView.swift
//  VillageMan
//
//  Created by cauca on 11/18/21.
//

import SwiftUI
import AVKit

struct FeedPadView: View {
    let items: [Feed]
    
    var body: some View {
        LazyVGrid(columns: [.init(.flexible()), .init(.flexible())],
                  alignment: .leading,
                  spacing: 10) {
            ForEach(items) { model in
                NavigationLink {
                    if let videoMp4 = model.videoMp4, let url = URL(string: videoMp4) {
                        let player = AVPlayer(url: url)
                        VideoPlayer(player: player).onAppear {
                            player.play()
                        }.onDisappear {
                            player.pause()
                        }
                    } else if let video = model.video {
                        VideoPlayerView(youtubeUrl: video)
                    } else {
                        FeedDetailView(service: RealService(), model: model)
                    }
                } label: {
                    MediumFeedCell(model: model)
                }
            }
        }
    }
}

struct FeedPadView_Previews: PreviewProvider {
    static var previews: some View {
        FeedPadView(items: [])
    }
}
