//
//  AVVideoView.swift
//  VillageMan
//
//  Created by cauca on 11/23/21.
//

import SwiftUI
import AVKit

struct AVVideoView: UIViewControllerRepresentable {
    
    private let player: AVPlayer
    
    init(url: URL) {
        self.player = AVPlayer(url: url)
    }
    
    init(player: AVPlayer) {
        self.player = player
    }
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.entersFullScreenWhenPlaybackBegins = true
        controller.player = self.player
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        uiViewController.player?.play()
    }
}
