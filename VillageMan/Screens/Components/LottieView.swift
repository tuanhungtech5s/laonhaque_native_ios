//
//  LottieView.swift
//  VillageMan
//
//  Created by cauca on 11/12/21.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    
    let name: String
    let loopMode: LottieLoopMode
    
    init(name: String, loopMode: LottieLoopMode = .playOnce) {
        self.name = name
        self.loopMode = loopMode
    }
    
    func makeUIView(context: Context) -> UIView {
        
        let view = UIView(frame: .zero)
        let animationView = AnimationView()
        let animation = Animation.named(name)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.play()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    
}

struct LottieView_Previews: PreviewProvider {
    static var previews: some View {
        LottieView(name: "success-tick")
    }
}
