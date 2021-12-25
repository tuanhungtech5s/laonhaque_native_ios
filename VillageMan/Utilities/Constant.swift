//
//  Constant.swift
//  VillageMan
//
//  Created by cauca on 11/15/21.
//

import Foundation
import UIKit
import SwiftUI

extension Color {
    static var mainColor: Color = Color(hex: "008f6e")
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex.replacingOccurrences(of: "#", with: ""))
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff

        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff
        )
    }
}

extension Font {
    static var robotoLagerTitle: Font = Font.custom("Roboto Medium", size: 21)
    static var robotoTitle: Font = Font.custom("Roboto Regular", size: 17)
    static var robotoTitleText: Font = Font.custom("Roboto Regular", size: 15)
    static var robotoBodyText: Font = Font.custom("Roboto Regular", size: 13)
    static var robotoCaption: Font = Font.custom("Roboto Regular", size: 13)
}
