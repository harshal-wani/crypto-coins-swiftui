//
//  CryptoItemView.swift
//  crypto-coins-swiftui
//
//  Created by Harshal Wani on 03/01/25.
//

import SwiftUI

struct CryptoItemView: View {
  var body: some View {
    
    HStack {
      VStack(alignment: .leading) {
        Text("Bitcoin")
          .font(.system(size: 20, weight: .semibold))
          .foregroundStyle(.secondary)
        Text("BTC")
          .font(.system(size: 16, weight: .bold))
          .foregroundStyle(.gray)
      }
      Spacer()
      
      Image("ic-coin")
        .resizable()
        .scaledToFit()
        .frame(width: 40, height: 40)
    }
    .padding(.top, 10)
  }
  
}

#Preview(traits: .fixedLayout(width: 300, height: 100)) {
  CryptoItemView()
}
