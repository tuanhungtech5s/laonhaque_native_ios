//
//  AirQuanlityView.swift
//  VillageMan
//
//  Created by cauca on 11/17/21.
//

import SwiftUI

struct AirQuanlityView: View {
    
    @State var position: Double
    
    init(aqi: Int = 0) {
        let ranges = [0...50] + (1...5).reduce([]) { partialResult, index in
            let start = index * 50 + 1
            return partialResult + [start...(index * 50 + 50)]
        } + [300...Int.max]
        let index = ranges.firstIndex(where: { $0 ~= aqi }) ?? 0
        position = Double(index)
    }
    
    private let colors = ["#009966",
                          "#ffde33",
                          "#ff9933",
                          "#cc0033",
                          "#660099",
                          "#7e0023"].map { Color(hex: $0 )}
    
    private let texts = [ "Tốt",
                          "Vừa Phải",
                          "Nhạy cảm",
                          "Không tốt",
                          "Rất không tốt",
                          "Nguy hiểm"]
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            let color: Color = position < 3 ? .white : colors[Int(position)]
            Text(texts[Int(position)]).foregroundColor(color)
                .font(.robotoTitleText)
            
            Slider(value: $position, in: 1...Double(colors.count))
                .disabled(true)
                .background(
                    LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing)
                        .frame(height: 10, alignment: .bottom)
                )
                .accentColor(.clear)
            
        }
    }
}

struct AirQuanlityView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            AirQuanlityView()
        }
        .background(Color.black)
        .previewLayout(.device)
    }
}

extension View {
    
    public func asUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)
        
        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()
        
        let image = controller.view.asUIImage()
        controller.view.removeFromSuperview()
        return image
    }
}

extension UIView {
    public func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
