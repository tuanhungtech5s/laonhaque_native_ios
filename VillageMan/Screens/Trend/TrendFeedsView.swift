//
//  TrendFeedsView.swift
//  VillageMan
//
//  Created by cauca on 11/5/21.
//

import SwiftUI
import Introspect
import SwiftUIRefresh
import Lottie

struct TrendFeedsView: View {
    @ObservedObject private(set) var viewModel: ViewModel
    @State var toFeedBack = false
    @State var showSplash = true
    @State private var isShowing = false
    
    var body: some View {
        if showSplash {
            splashView
        } else {
            NavigationView {
                switch self.viewModel.items {
                case .loaded(let trends):
                    loadedView(trends)
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar(content: {
                            ToolbarItem(placement: .principal) {
                                Image("logo")
                                    .resizable()
                                    .aspectRatio(4, contentMode: .fit)
                                    .frame(height: 44, alignment: .center)
                            }
                        })
                        .pullToRefresh(isShowing: $isShowing, onRefresh: {
                            self.viewModel.load(offset: 0)
                            self.isShowing = false
                        })
                case .failed:
                    ErrorView {
                        self.viewModel.load(offset: 0)
                    }
                default:
                    ActivityIndicatorView()
                }
            }.onAppear {
                self.viewModel.load(offset: 0)
            }
        }
        
    }
    
    func loadedView(_ trends: Trends) -> some View {
        ZStack {
            let source = trends.items
            if UIDevice.current.userInterfaceIdiom == .pad {
                ScrollView(.vertical, showsIndicators: true) {
                    ForEach(source) { trend in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(trend.title).font(.robotoLagerTitle)
                            FeedPadView(items: trend.items)
                        }
                    }
                }.padding(16)
            } else {
                List {
                    ForEach(source) { trend in
                        Section(header: Text(trend.title).font(.robotoLagerTitle)) {
                            var items = trend.items
                            let lager = items.removeFirst()
                            LagerFeedCell(model: lager)
                            
                            ForEach(items) { feed in
                                MediumFeedCell(model: feed)
                            }
                        }
                        .textCase(.none)
                    }
                }
                .listStyle(.plain)
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    if let phone = trends.phone {
                        PulseButton(systemImageName: "phone") {
                            guard let url = URL(string: "tel://\(phone)") else { return }
                            UIApplication.shared.open(url, options: [:])
                        }
                    } else {
                        NavigationLink(isActive: self.$toFeedBack) {
                            FeebackView(viewModel: .init(service: RealService()))
                        } label: {
                            PulseButton {
                                self.toFeedBack.toggle()
                            }.padding(.bottom, 10)
                        }
                    }
                    
                }
            }
            .padding(.bottom, 10)
        }
    }
    
    var splashView: some View {
        VStack {
            Image("splash", bundle: .main)
                .resizable()
                .renderingMode(.original)
                .aspectRatio(1, contentMode: .fit)
                .ignoresSafeArea(.all)
                .frame(width: showSplash ? 320 : nil, height: showSplash ? 320 : nil, alignment: .center)
                .scaleEffect(showSplash ? 1 : 2)
                .opacity(showSplash ? 1 : 0)
                .onAppear(perform: animateSplash)
            if !showSplash {
                Spacer()
            }
        }
        
    }
    
    func animateSplash() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(.easeOut(duration: 0.5)) {
                self.showSplash = false
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.viewModel.load(offset: 0)
        }
    }
}

struct HotFeedsView_Previews: PreviewProvider {
    static var previews: some View {
        TrendFeedsView(viewModel: .init(service: ServiceMock()))
            .navigationViewStyle(.stack)
            .previewLayout(.device)
    }
}

extension TrendFeedsView {
    final class ViewModel: ObservableObject {
        @Published var items: Loadable<Trends> = .notRequested
        
        let service: Service
        let cancelBag = CancelBag()
        
        init(service: Service) {
            self.service = service
        }
        
        func load(offset: Int) {
            service.trends(offset: offset).sinkToLoadable { loadable in
                self.items = loadable
            }.store(in: cancelBag)
        }
    }
}
