//
//  CategoryView.swift
//  VillageMan
//
//  Created by cauca on 11/7/21.
//

import SwiftUI

struct CategoryView: View {
    
    let category: [Category]
    @State var selectedId: String = ""
    let selection: ((Category) -> Void)
    
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: [.init(.flexible(minimum: 10, maximum: .infinity), spacing: 10, alignment: .center)]) {
                ForEach(category) { model in
                        Button.init {
                            self.selectedId = model.id == self.selectedId ? "" : model.id
                            self.selection(model)
                        } label: {
                            Text(model.name.uppercased())
                                .underline(self.selectedId == model.id, color: .mainColor)
                                .padding(EdgeInsets.init(top: 5, leading: 10, bottom: 5, trailing: 10))
                                .foregroundColor(self.selectedId == model.id ? Color.mainColor : Color.gray)
                        }
                }
            }
        }
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(category: Category.items, selection: { _ in })
            .previewLayout(.fixed(width: 320, height: 40))
    }
}
