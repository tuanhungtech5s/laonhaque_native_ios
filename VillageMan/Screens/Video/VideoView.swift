//
//  VideoView.swift
//  VillageMan
//
//  Created by cauca on 11/7/21.
//

import SwiftUI
import Combine
import AVKit

struct VideoView: View {
    
    @ObservedObject var viewModel: ViewModel
    @State var isShowing: Bool = false
    
    var body: some View {
        NavigationView {
            switch self.viewModel.items {
            case .loaded(let items):
                
                    if UIDevice.current.userInterfaceIdiom == .pad {
                        ScrollView(.vertical, showsIndicators: true) {
                            FeedPadView(items: items.items)
                        }.navigationBarTitle("Video", displayMode: .large)
                    } else {
                        List(items.items) { feed in
                            LagerFeedCell(model: feed).onAppear {
                                if items.items.count < items.total, feed == items.items.last {
                                    self.viewModel.load(offset: items.items.count)
                                }
                            }
                        }
                        .pullToRefresh(isShowing: $isShowing, onRefresh: {
                            self.viewModel.load(offset: 0)
                            self.isShowing = false
                        })
                        .listStyle(.plain)
                        .listRowInsets(EdgeInsets())
                        .navigationBarTitle("Video", displayMode: .large)
                    }
                
               
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

struct VideoView_Previews: PreviewProvider {
    static var previews: some View {
        VideoView(viewModel: .init(service: ServiceMock()))
    }
}

extension VideoView {
    final class ViewModel: ObservableObject {
        
        @Published var items: Loadable<Feeds> = .notRequested
        
        private let service: Service
        let cancelBag = CancelBag()
        
        init(service: Service) {
            self.service = service
        }
        
        func load(offset: Int) {
            service.video(offset: offset).map({ response in
                if offset == 0 {
                    return response.feeds
                }
                let items = (self.items.value?.items ?? []) + response.feeds.items
                return Feeds(total: response.feeds.total,
                             offset: response.feeds.offset,
                             limit: response.feeds.limit,
                             items: Array(Set(items)).sorted(by: >))
            }).catch({ error -> AnyPublisher<Feeds, Error> in
                debugPrint(error)
                return Empty().eraseToAnyPublisher()
            }).sinkToLoadable { result in
                self.items = result
            }.store(in: cancelBag)
        }
    }
}
