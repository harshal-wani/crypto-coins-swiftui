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
  private var cancellables = Set<AnyCancellable>()
  
  // MARK: - Internal State
  private var cryptoCoins = [CryptoItem]()
  private var filterSet = [CryptoFilterSet]()
  
  @Published var filterTags = [TagViewItem]()
  @Published private(set) var filteredCoins = [CryptoItem]()
  @Published private(set) var dataState: DataState = .loading
  @Published var searchPhrase = ""
  
  // MARK: - Initialization
  init(dataProvider: CryptoDataProviding) {
    self.dataProvider = dataProvider
    setupFilterTags()
    bindPublishers()
  }
  
  // MARK: - Data Fetching
  func initializeData() {
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
  
  // MARK: - Binding Publishers
  private func bindPublishers() {
    bindCoinsPublisher()
    bindSearchPhrasePublisher()
  }
  
  private func bindCoinsPublisher() {
    dataProvider.coinsPublisher
      .receive(on: DispatchQueue.main)
      .sink { [weak self] coins in
        self?.cryptoCoins = coins
        self?.filteredCoins = coins
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
    // Implement routing logic here if needed
  }
  
  // MARK: - Private Methods
  private func setupFilterTags() {
    filterTags = CryptoFilterSet.allCases.map { TagViewItem(text: $0.text) }
  }
  
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
