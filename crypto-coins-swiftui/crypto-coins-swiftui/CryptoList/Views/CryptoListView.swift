//
//  CryptoListView.swift
//  crypto-coins-swiftui
//
//  Created by Harshal Wani on 03/01/25.
//

import SwiftUI
import SwiftUICustomTagListView

struct CryptoListView: View {
  
  @StateObject private var viewModel: CryptoViewModel
  
  init(viewModel: CryptoViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var filterTagsView: [SwiftUICustomTagView<TagsView>] {
    viewModel.filterTags.indices.map { item in
      SwiftUICustomTagView(content: {
        TagsView(data: $viewModel.filterTags[item]) { tag, action in
          handleTagTap(tag, action: action)
        }
      })
    }
  }
  
  var body: some View {
    NavigationStack {
      VStack {
        SwiftUICustomTagListView(filterTagsView, horizontalSpace: 8, verticalSpace: 8)
          .padding(.leading, 16)
          .padding(.top, 16)
          .frame(minHeight: 50) // Minimum height for the tag list view
          .fixedSize(horizontal: false, vertical: true)
        List {
          ForEach(viewModel.filteredCoins, id: \.self) { item in
            CryptoItemRow(cryptoItem: item)
          }
        }
      }
      
      .navigationTitle("Crypto List")
      .onAppear {
        viewModel.fetchAndInitializeData()
      }
    }
    .searchable(text: $viewModel.searchPhrase)
  }
  
  private func handleTagTap(_ text: String, action: FilterAction) {
    print("text: \(text), action: \(action)")
      viewModel.filterCoins(with: text, action: action, searchPhrase: viewModel.searchPhrase)
  }
}

#Preview {
  let dp = CryptoDataProvider(apiService: APIService.shared)
  let vm = CryptoViewModel(dataProvider: dp)
  CryptoListView(viewModel: vm)
}
