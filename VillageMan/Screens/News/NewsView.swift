//
//  NewsView.swift
//  VillageMan
//
//  Created by cauca on 11/6/21.
//

import SwiftUI
import Combine

struct NewsView: View {
    
    @ObservedObject private(set) var viewModel: ViewModel
    @ObservedObject var searchBar: SearchBar = SearchBar()
    @State var isShowing: Bool = false
    @State var toFeedBack = false
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        self.searchBar.$text.assign(to: &self.viewModel.$text)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.text.isEmpty {
                    switch self.viewModel.feeds {
                    case .loaded(let result):
                        itemsView(result.categories, result.feeds.items, result.phone)
                            .pullToRefresh(isShowing: $isShowing, onRefresh: {
                                self.viewModel.loadMore(offset: 0)
                                self.isShowing = false
                            })
                    case .failed:
                        ErrorView {
                            self.viewModel.loadMore(offset: 0)
                        }
                    default:
                        ActivityIndicatorView()
                    }
                } else {
                    switch self.viewModel.searchResults {
                    case .loaded(let items):
                        if items.isEmpty {
                            Label("Không có kết quả", systemImage: "magnifyingglass")
                                .foregroundColor(.gray)
                                .font(.largeTitle)
                        } else {
                            List(items) { model in
                                MediumFeedCell(model: model)
                            }
                            .listStyle(.plain)
                            .listRowInsets(EdgeInsets())
                        }
                    case .isLoading:
                        ActivityIndicatorView()
                    default:
                        EmptyView()
                    }
                }
                
            }
        }.onAppear {
            self.viewModel.categoryId.send("")
        }
    }
    
    func itemsView(_ category: [Category], _ items: [Feed], _ phone: String?) -> some View {
        ZStack {
            List {
                CategoryView(category: category, selectedId: self.viewModel.currentId) { category in
                    let id = self.viewModel.currentId == category.id ? "" : category.id
                    self.viewModel.categoryId.send(id)
                    self.viewModel.currentId = id
                }.frame(height: 40, alignment: .leading)
                
                ForEach(items) { feed in
                    if UIDevice.current.userInterfaceIdiom == .pad {
                        MediumFeedCell(model: feed).onAppear {
                            if feed == items.last {
                                self.viewModel.loadMore(offset: items.count)
                            }
                        }
                    } else {
                        LagerFeedCell(model: feed)
                            .onAppear {
                                if feed == items.last {
                                    self.viewModel.loadMore(offset: items.count)
                                }
                            }
                    }
                    
                }
                
            }
            .listStyle(.plain)
            .listRowInsets(EdgeInsets())
            .add(self.searchBar)
            .navigationBarTitle("Tin tức", displayMode: .automatic)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    NavigationLink(isActive: self.$toFeedBack) {
                        FeebackView(viewModel: .init(service: RealService()))
                    } label: {
                        PulseButton {
                            self.toFeedBack.toggle()
                        }.padding(.bottom, 10)
                    }
                    
                }
            } .padding(.bottom, 10)
            
        }
    }
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView(viewModel: .init(service: ServiceMock()))
    }
}

extension NewsView {
    final class ViewModel: ObservableObject {
        
        @Published var feeds: Loadable<FeedResponse> = .notRequested
        @Published var searchResults: Loadable<[Feed]> = .notRequested
        @Published var text: String = ""
        
        let categoryId = PassthroughSubject<String, Error>()
        var currentId = ""
        var phone: String?
        
        private var itemsCount = 0
        private var categories: [Category] = []
        private let service: Service
        private let cancelBag = CancelBag()
        
        init(service: Service) {
            self.service = service
            
            categoryId.filter({ $0.isEmpty }).flatMap { _ in
                return self.service.feeds(offset: 0)
            }.sinkToLoadable { result in
                self.feeds = result
                self.categories = result.value?.categories ?? []
                self.phone = result.value?.phone
            }.store(in: cancelBag)
            
            categoryId.filter({ !$0.isEmpty }).flatMap { id in
                return self.service.news(byCategory: id, offset: self.itemsCount)
                    .map { response in
                        return FeedResponse(code: 200,
                                            categories: self.categories,
                                            feeds: .init(total: response.items.total,
                                                         offset: response.items.offset,
                                                         limit: response.items.total,
                                                         items: response.items.items),
                                            phone: self.phone)
                    }
                
            }.sinkToLoadable { result in
                self.feeds = result
            }.store(in: cancelBag)
            
            self.$text
                .debounce(for: .seconds(0.3), scheduler: RunLoop.main)
                .filter({ !$0.isEmpty }).flatMap { keyword in
                    self.service.search(keyword: keyword)
                        .map({ $0.items.items })
                        .handleEvents(receiveSubscription: { _ in
                            self.searchResults = .isLoading(last: [], cancelBag: self.cancelBag)
                        })
                        .replaceError(with: [])
                }
                .sinkToLoadable { result in
                    self.searchResults = result
                }.store(in: cancelBag)
        }
        
        func loadMore(offset: Int) {
            if offset == (self.feeds.value?.feeds.total ?? 0) {
                return
            }
            if self.currentId.isEmpty {
                self.service.feeds(offset: offset)
                    .map({ response in
                        let items = (self.feeds.value?.feeds.items ?? []) + response.feeds.items
                        return FeedResponse(code: response.code,
                                            categories: response.categories,
                                            feeds: .init(total: response.feeds.total,
                                                         offset: response.feeds.offset,
                                                         limit: response.feeds.offset,
                                                         items: Array(Set(items)).sorted(by: >)),
                                            phone: self.phone)
                    }).catch({ error -> AnyPublisher<FeedResponse, Error> in
                        debugPrint(error)
                        return Empty<FeedResponse, Error>().eraseToAnyPublisher()
                    })
                                .sinkToLoadable { result in
                        self.feeds = result
                    }.store(in: cancelBag)
            } else {
                self.service.news(byCategory: self.currentId, offset: offset)
                    .map { response in
                        return FeedResponse(code: 200,
                                            categories: self.categories,
                                            feeds: .init(total: response.items.total,
                                                         offset: response.items.offset,
                                                         limit: response.items.total,
                                                         items: response.items.items),
                                            phone: self.phone)
                    }.catch({ error -> AnyPublisher<FeedResponse, Error> in
                        debugPrint(error)
                        return Empty<FeedResponse, Error>().eraseToAnyPublisher()
                    }).sinkToLoadable { result in
                        self.feeds = result
                    }.store(in: cancelBag)
            }
        }
    }
}
