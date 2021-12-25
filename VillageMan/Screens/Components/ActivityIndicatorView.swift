//
//  ActivityIndicatorView.swift
//  CountriesSwiftUI
//
//  Created by Alexey Naumov on 25.10.2019.
//  Copyright © 2019 Alexey Naumov. All rights reserved.
//

import SwiftUI

struct ActivityIndicatorView: View {
    var body: some View {
        ZStack {
            LottieView(name: "loading", loopMode: .loop)
                .frame(width: 120, height: 120, alignment: .center)
            Image("adaptive-icon", bundle: .main)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 60, height: 60, alignment: .center)
        }
    }
}
