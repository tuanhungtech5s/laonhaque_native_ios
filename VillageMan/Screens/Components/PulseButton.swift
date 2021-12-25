//
//  PulseButton.swift
//  VillageMan
//
//  Created by cauca on 11/12/21.
//

import SwiftUI

struct CircleData: Hashable {
    let width: CGFloat
    let opacity: Double
}

struct PulseButton: View {
    // MARK: - Properties
        @State private var isAnimating: Bool = false
    
        var color: Color
        var systemImageName: String
        var buttonWidth: CGFloat
        var numberOfOuterCircles: Int
        var animationDuration: Double
        var circleArray = [CircleData]()
        var action: () -> Void

        init(color: Color = Color.green,
             systemImageName: String = "square.and.pencil",
             buttonWidth: CGFloat = 50,
             numberOfOuterCircles: Int = 2,
             animationDuration: Double = 2,
             action: @escaping () -> Void) {
            
            self.color = color
            self.systemImageName = systemImageName
            self.buttonWidth = buttonWidth
            self.numberOfOuterCircles = numberOfOuterCircles
            self.animationDuration = animationDuration
            self.action = action
            
            var circleWidth = self.buttonWidth
            var opacity = (numberOfOuterCircles > 4) ? 0.40 : 0.20
            
            for _ in 0..<numberOfOuterCircles {
                circleWidth += 20
                self.circleArray.append(CircleData(width: circleWidth, opacity: opacity))
                opacity -= 0.05
            }
        }

        // MARK: - Body
        var body: some View {
            ZStack {
                Group {
                    ForEach(circleArray, id: \.self) { cirlce in
                        Circle().fill(self.color)
                            .opacity(self.isAnimating ? cirlce.opacity : 0)
                            .frame(width: cirlce.width, height: cirlce.width, alignment: .center)
                            .scaleEffect(self.isAnimating ? 1 : 0)
                    }
                    
                }
                .animation(Animation.easeInOut(duration: animationDuration).repeatForever(autoreverses: true),
                   value: self.isAnimating)

                Circle()
                    .fill(self.color).opacity(0.5)
                    .frame(width: self.buttonWidth * 1.2, height: self.buttonWidth * 1.2, alignment: .center)
                
                Button(action: self.action) {
                    Image(systemName: self.systemImageName)
                        .resizable()
                        .padding(self.buttonWidth * 0.25)
                        .accentColor(.white)
                        .rotationEffect(.degrees(self.isAnimating ? -15 : 0))
                        .animation(Animation.easeInOut(duration: 0.3).repeatForever(autoreverses: true),
                           value: self.isAnimating)
                }
                .background(Circle().fill(color))
                .frame(width: self.buttonWidth, height: self.buttonWidth, alignment: .center)
                .onAppear(perform: {
                    self.isAnimating.toggle()
                })
            } //: ZSTACK
        }
}

struct PulseButton_Previews: PreviewProvider {
    static var previews: some View {
        PulseButton(action: { }).previewLayout(.fixed(width: 120, height: 120))
    }
}
