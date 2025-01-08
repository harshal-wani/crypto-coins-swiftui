//
//  CryptoItemRow.swift
//  crypto-coins-swiftui
//
//  Created by Harshal Wani on 03/01/25.
//

import SwiftUI

struct CryptoItemRow: View {
  let cryptoItem: CryptoItem
  
  var body: some View {
    HStack {
      VStack(alignment: .leading, spacing: 4) {
        Text(cryptoItem.name)
          .font(.system(size: 20, weight: .semibold))
          .foregroundColor(.secondary)
        Text(cryptoItem.symbol)
          .font(.system(size: 16, weight: .bold))
          .foregroundColor(.gray)
      }
      Spacer()
      iconView
    }
    .padding(.vertical, 10)
  }
  
  
  @ViewBuilder
  private var iconView: some View {
    if !cryptoItem.isActive {
      imageView(named: "ic-inactive")
    } else {
      switch cryptoItem.type {
      case .coin:
        imageView(named: "ic-coin")
      case .token:
        imageView(named: "ic-token")
      case .unknown:
        EmptyView()
      }
    }
  }
  
  private func imageView(named: String) -> some View {
    Image(named)
      .resizable()
      .scaledToFit()
      .frame(width: 40, height: 40)
  }
}

#Preview(traits: .fixedLayout(width: 300, height: 100)) {
  do {
    let jsonData = Data("""
        {
            "name": "Monero",
            "symbol": "XMR",
            "is_new": false,
            "is_active": true,
            "type": "coin"
        }
        """.utf8)
    let mock: CryptoItem = try JSONDecoder().decode(CryptoItem.self, from: jsonData)
    return CryptoItemRow(cryptoItem: mock)
  } catch {
    return Text("Error loading preview")
  }
}
