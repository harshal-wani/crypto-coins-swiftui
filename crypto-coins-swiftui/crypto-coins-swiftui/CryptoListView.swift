//
//  CryptoListView.swift
//  crypto-coins-swiftui
//
//  Created by Harshal Wani on 03/01/25.
//

import SwiftUI
import SwiftUICustomTagListView

struct CryptoListView: View {
  
  @State private var data: [TagViewItem] = [
    .init(text: "one"),
    .init(text: "two"),
    .init(text: "three"),
     ]
     
  var views: [SwiftUICustomTagView<TagsView>] {
    data.indices.map { item in
      SwiftUICustomTagView(content: {
        TagsView(data: $data[item])
      })
    }
  }
  
    var body: some View {
        VStack {
          SwiftUICustomTagListView(views, horizontalSpace: 8, verticalSpace: 8)
            .padding()
          List {
            CryptoItemView()
            CryptoItemView()
            CryptoItemView()
            CryptoItemView()
            CryptoItemView()
          }
        }
    }
}

#Preview {
  CryptoListView()
}
