//
//  FeedDetailView.swift
//  VillageMan
//
//  Created by cauca on 11/6/21.
//

import SwiftUI
import WebKit

struct FeedDetailView: View {
    @ObservedObject private(set) var viewModel: ViewModel
    @State private var webViewHeight: CGFloat = 40
    
    init(service: Service, model: Feed) {
        self.viewModel = ViewModel(service: service, id: model.id)
        self.viewModel.load(feedId: model.id)
    }
    
    var body: some View {
        switch self.viewModel.model {
        case .loaded(let items):
            List {
                if let feed = items.items.first {
                    LagerFeedCell(model: feed.feed, canNavigate: false)
                    WebView(dynamicHeight: $webViewHeight,
                            webView: WKWebView(frame: CGRect(x: 0, y: 0, width: 320, height: 20), configuration: .init()),
                            content: feed.content)
                        .frame(height: webViewHeight, alignment: .leading)
                    if let link = feed.link, let url = URL(string: link) {
                        Link(destination: url) {
                            Text("Đọc bài gốc: \(url.host ?? "")").font(.robotoTitle)
                        }
                    }
                }
                if let related = items.relatedNews {
                    Text("Có thể bạn quan tâm")
                        .font(.title)
                    ForEach(related) { feed in
                        MediumFeedCell(model: feed).onTapGesture {
                            self.viewModel.load(feedId: feed.id)
                        }
                    }
                }
            }
            .navigationTitle(items.items.first?.name ?? "")
            .navigationBarTitleDisplayMode(.inline)
            .listStyle(.plain)
        case .failed:
            ErrorView {
                self.viewModel.load()
            }
        default:
            ActivityIndicatorView()
        }
    }
}

struct FeedDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FeedDetailView(service: ServiceMock(), model: Feeds.example.items[0]).previewLayout(.sizeThatFits)
    }
}

extension FeedDetailView {
    final class ViewModel: ObservableObject {
        
        @Published var model: Loadable<DetailItems<FeedDetail, Feed>> = .notRequested
        
        let service: Service
        let cancelBag = CancelBag()
        let id: String
        
        init(service: Service, id: String) {
            self.service = service
            self.id = id
        }
        
        func load(feedId: String? = nil) {
            self.service.detail(id: feedId ?? self.id)
                .handleEvents(receiveSubscription: { _ in
                    self.model = .isLoading(last: self.model.value, cancelBag: self.cancelBag)
                })
                .sinkToLoadable { result in
                    self.model = result
                }.store(in: cancelBag)
        }
    }
}
