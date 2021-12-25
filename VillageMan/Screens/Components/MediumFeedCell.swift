//
//  MediumFeedCell.swift
//  VillageMan
//
//  Created by cauca on 11/5/21.
//

import SwiftUI
import Kingfisher
import AVKit

struct MediumFeedCell: View {
    
    let model: Feed
    
    var body: some View {
        ZStack {
            NavigationLink {
               if let video = model.video {
                    VideoPlayerView(youtubeUrl: video)
                } else {
                    FeedDetailView(service: RealService(), model: model)
                }
            } label: { }
            .opacity(0)
            VStack {
                HStack(alignment: .top, spacing: 10) {
                    
                    KFImage.url(URL(string: model.img))
                        .placeholder {
                            ActivityIndicatorView()
                                .frame(width: 125, height: 125, alignment: .center)
                        }
                        .resizable()
                        .cornerRadius(8)
                        .aspectRatio(16 / 10, contentMode: .fit)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(model.name)
                            .font(.robotoTitleText)
                        
                        Text(model.createTime)
                            .font(.robotoCaption)
                            .foregroundColor(.gray)
                        
                        Text(model.category)
                            .lineLimit(1)
                            .font(.robotoCaption)
                            .foregroundColor(.white)
                            .padding(EdgeInsets.init(top: 3, leading: 10, bottom: 3, trailing: 10))
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.mainColor))
                        
                        if let link = model.link, let url = URL(string: link), let host = url.host {
                            Text("Nguồn: \(host)")
                                .font(.robotoCaption)
                                .padding(3)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(Color.green).opacity(0.8)
                                        .opacity(0.3)
                                )
                                
                        }
                        
                    }
                    Spacer()
                }
            }.frame(minHeight: 40, idealHeight: 80, maxHeight: 150, alignment: .center)
        }
    }
}

struct MediumFeedCell_Previews: PreviewProvider {
    static var previews: some View {
        List {
            Section(header: Text("Header").font(Font.largeTitle)) {
                ForEach(Feeds.example.items) { feed in
                    MediumFeedCell(model: feed)
                }
            }
        }
        .listStyle(.grouped)
        .previewLayout(.device)
    }
}
