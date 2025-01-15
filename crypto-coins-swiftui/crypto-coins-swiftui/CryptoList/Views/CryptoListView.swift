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
  
  private var filterTagsView: [SwiftUICustomTagView<TagsView>] {
    viewModel.filterTags.indices.map { index in
      SwiftUICustomTagView {
        TagsView(data: $viewModel.filterTags[index]) { tag, action in
          handleTagTap(tag, action: action)
        }
      }
    }
  }
  
  var body: some View {
    NavigationStack {
      VStack {
        Spacer()
        SwiftUICustomTagListView(filterTagsView, horizontalSpace: 8, verticalSpace: 8)
          .padding(.leading, 16)
          .padding(.top, 16)
          .padding(.bottom, -30)
          .background(Color.gray.opacity(0.3))
        List(viewModel.filteredCoins, id: \.self) { item in
          CryptoItemRow(cryptoItem: item)
        }
      }
      .navigationTitle("Crypto List")
      .onAppear {
        viewModel.initializeData()
      }
    }
    .searchable(text: $viewModel.searchPhrase)
  }
  
  private func handleTagTap(_ text: String, action: FilterAction) {
    viewModel.filterCoins(with: text, action: action, searchPhrase: viewModel.searchPhrase)
  }
}

struct ViewHeightKey: PreferenceKey {
  static var defaultValue: CGFloat = 0
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = nextValue()
  }
}

#Preview {
  let dataProvider = CryptoDataProvider(apiService: APIService.shared)
  let viewModel = CryptoViewModel(dataProvider: dataProvider)
  CryptoListView(viewModel: viewModel)
}
