//
//  WeatherView.swift
//  VillageMan
//
//  Created by cauca on 11/8/21.
//

import SwiftUI
import Combine

struct WeatherView: View {
    
    @ObservedObject private(set) var viewModel: ViewModel
    @State var isShowing: Bool = false
    
    var body: some View {
        NavigationView {
            switch self.viewModel.tools {
            case .loaded(let tools):
                if UIDevice.current.userInterfaceIdiom == .pad {
                    padView(tools: tools)
                } else {
                    phoneView(tools: tools)
                }
            case .failed:
                ErrorView {
                    self.viewModel.load()
                }
            default:
                ActivityIndicatorView()
            }
        }.onAppear {
            self.viewModel.load()
        }
    }
    
    func phoneView(tools: Tools) -> some View {
        List {
            Section {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: [.init(.flexible(minimum: 10, maximum: .infinity), spacing: 10, alignment: .center)]) {
                        ForEach(tools.aqis) { aqi in
                            AQICell(model: aqi)
                                .frame(width: 160, alignment: .leading)
                        }
                    }
                }
            } header: {
                Text("Chất lượng không khí")
                    .font(Font.robotoTitle)
            }.textCase(.none)
            
            Section {
                ForEach(tools.weathers) { model in
                    WeatherCell(model: model, aiq: nil)
                        .frame(minWidth: 120, maxWidth: .infinity, minHeight: 40, maxHeight: .infinity, alignment: .topLeading)
                }
            } header: {
                Text("Thời tiết")
                    .font(Font.robotoTitle)
            }.textCase(.none)

        }
        .pullToRefresh(isShowing: $isShowing, onRefresh: {
            self.viewModel.load()
            self.isShowing = false
        })
        .listStyle(.plain)
        .listRowInsets(EdgeInsets())
        .navigationBarTitle("Tiện ích", displayMode: .large)
    }
    
    func padView(tools: Tools) -> some View {
        
        List {
            Section {
                LazyVGrid(columns: [.init(.flexible()),
                                    .init(.flexible()),
                                    .init(.flexible()),
                                    .init(.flexible())], alignment: .leading, spacing: 8) {
                    ForEach(tools.aqis) { aqi in
                        AQICell(model: aqi)
                    }
                }
            } header: {
                Text("Chất lượng không khí")
                    .font(Font.robotoTitle)
            }
            
            Section {
                LazyVGrid(columns: [.init(.flexible()),
                                    .init(.flexible()),
                                    .init(.flexible())], alignment: .leading, spacing: 8) {
                ForEach(tools.weathers) { model in
                    WeatherCell(model: model, aiq: nil)
                        .frame(minWidth: 120, maxWidth: .infinity, minHeight: 40, maxHeight: .infinity, alignment: .topLeading)
                }
                }
                
            } header: {
                Text("Thời tiết")
                    .font(Font.robotoTitle)
            }
            
        }
        .listStyle(.plain)
        .listRowInsets(EdgeInsets())
        .navigationBarTitle("Tiện ích", displayMode: .large)
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(viewModel: .init(service: ServiceMock()))
        .navigationViewStyle(.stack)
        .background(Color.black)
        .previewLayout(.device)
    }
}

extension WeatherView {
    final class ViewModel: ObservableObject {
        private let service: Service
        private let cancelBag = CancelBag()
        
        @Published var tools: Loadable<Tools> = .notRequested
        
        init(service: Service) {
            self.service = service
        }
        
        func load() {
            self.service.tools().sinkToLoadable { result in
                self.tools = result
            }.store(in: cancelBag)
        }
    }
}
