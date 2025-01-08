//
//  crypto_coins_swiftuiApp.swift
//  crypto-coins-swiftui
//
//  Created by Harshal Wani on 03/01/25.
//

import SwiftUI

@main
struct crypto_coins_swiftuiApp: App {
    var body: some Scene {
        WindowGroup {
          let dp = CryptoDataProvider(apiService: APIService.shared)
          let vm = CryptoViewModel(dataProvider: dp)
          CryptoListView(viewModel: vm)
        }
    }
}
