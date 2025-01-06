//
//  CryptoListView.swift
//  crypto-coins-swiftui
//
//  Created by Harshal Wani on 03/01/25.
//

import SwiftUI

struct CryptoListView: View {
    var body: some View {
        VStack {
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
