//
//  VideoPlayerView.swift
//  VillageMan
//
//  Created by cauca on 11/8/21.
//

import SwiftUI
import youtube_ios_player_helper

struct VideoPlayerView: UIViewRepresentable {
    private let playerView: YTPlayerView = YTPlayerView(frame: UIScreen.main.bounds)
    let youtubeUrl: String
    
    func makeUIView(context: Context) -> YTPlayerView {
        if let videoID = self.youtubeUrl.components(separatedBy: "/").last {
            self.playerView.load(withVideoId: videoID)
        }
        return playerView
    }
    
    func updateUIView(_ uiView: YTPlayerView, context: Context) {
        uiView.playVideo()
    }
    
}
