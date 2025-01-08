//
//  CryptoViewModel.swift
//  crypto-coins-swiftui
//
//  Created by Harshal Wani on 07/01/25.
//

import Foundation
import Combine

protocol CryptoListListener {
  func search(for searchPhrase: String)
  func filterCoins(with filter: String, action: FilterAction, searchPhrase: String)
  func resetResult()
  func didTapOnCoin(_ cryptoItem: CryptoItem)
}

protocol CryptoRouteable {
  func routeToDetail(for cryptoItem: CryptoItem)
}

final class CryptoViewModel: CryptoListListener, ObservableObject {
  
  // MARK: - Dependencies
  private let dataProvider: CryptoDataProviding
//  private let router: CryptoRouteable
  
  // MARK: - Internal State
  private var cryptoCoins: [CryptoItem] = []
  private var filterSet: [CryptoFilterSet] = []
  
  @Published var filterTags: [TagViewItem] = []
  @Published private(set) var filteredCoins: [CryptoItem] = []
  @Published private(set) var dataState: DataState = .loading
  @Published var searchPhrase: String = ""

  
  private var cancellables: Set<AnyCancellable> = []
  
  // MARK: - Initialization
  init(dataProvider: CryptoDataProviding) {
    self.dataProvider = dataProvider
//    self.router = router
    fetchAndInitializeData()
    filterTags = CryptoFilterSet.allCases.map { TagViewItem(text: $0.text) }
    bindCoinsPublisher()
    bindSearchPhrasePublisher()
  }
  
  // MARK: - Data Fetching
  func fetchAndInitializeData() {
    dataState = .loading
    Task {
      do {
        try await dataProvider.fetchData()
        DispatchQueue.main.async {
          self.dataState = .success
        }
      } catch {
        DispatchQueue.main.async {
          self.dataState = .error(error.localizedDescription)
        }
      }
    }
  }
  
  private func bindCoinsPublisher() {
    dataProvider.coinsPublisher
      .sink { [weak self] coins in
        self?.cryptoCoins = coins
        DispatchQueue.main.async {
          self?.filteredCoins = coins
        }
      }
      .store(in: &cancellables)
  }
  
  private func bindSearchPhrasePublisher() {
    $searchPhrase
      .dropFirst()
      .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
      .sink { [weak self] text in
        self?.applyFilters(searchPhrase: text)
      }
      .store(in: &cancellables)
  }
  

  // MARK: - Public Methods
  func search(for searchPhrase: String) {
    self.searchPhrase = searchPhrase
  }
  
  func filterCoins(with filter: String, action: FilterAction, searchPhrase: String) {
    updateFilterSet(filter, action: action)
    applyFilters(searchPhrase: searchPhrase)
  }
  
  func resetResult() {
    filteredCoins = cryptoCoins
  }
  
  func didTapOnCoin(_ cryptoItem: CryptoItem) {
//    router.routeToDetail(for: cryptoItem)
  }
  
  // MARK: - Private Methods
  
  private func filterCoinsBySearchPhrase(_ searchPhrase: String) -> [CryptoItem] {
    cryptoCoins.filter { $0.name.range(of: searchPhrase, options: .caseInsensitive) != nil }
  }
  
  private func updateFilterSet(_ filter: String, action: FilterAction) {
      if let filterItem = CryptoFilterSet.allCases.first(where: { $0.text == filter }) {
          switch action {
          case .add:
              if !filterSet.contains(filterItem) {
                  filterSet.append(filterItem)
              }
          case .remove:
              filterSet.removeAll { $0 == filterItem }
          }
      }
  }

  
  private func applyFilters(searchPhrase: String) {
    let filteredBySearch = searchPhrase.isEmpty ? cryptoCoins : filterCoinsBySearchPhrase(searchPhrase)
    
    filteredCoins = filteredBySearch.filter { coin in
      filterSet.allSatisfy { $0.matches(item: coin) }
    }
  }
}
