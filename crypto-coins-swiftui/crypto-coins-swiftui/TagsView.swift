//
//  TagsView.swift
//  crypto-coins-swiftui
//
//  Created by Harshal Wani on 06/01/25.
//

import SwiftUI
import SwiftUICustomTagListView

// MARK: - Define your own component

struct TagsView: View {
  @Binding var data: TagViewItem
  
  private let selectedTick = " ✅"
  
  var body: some View {
    Text(data.text)
      .font(.system(size: 16, weight: .medium))
      .padding(8)
      .background(gradientBackground)
      .cornerRadius(7)
      .foregroundColor(.white)
      .onTapGesture {
        handleTap()
      }
  }
  
  private var gradientBackground: LinearGradient {
    LinearGradient(
      gradient: Gradient(colors: [.gray]),
      startPoint: .top,
      endPoint: .bottom
    )
  }
  
  private func handleTap() {
    print("[Pressed] \(data.text)")
    data.isSelected.toggle()
    updateText()
  }
  
  private func updateText() {
    if data.isSelected {
      data.text.append(selectedTick)
    } else {
      data.text = data.text.replacingOccurrences(of: selectedTick, with: "")
    }
  }
}

// MARK: - TagViewItem Model

struct TagViewItem {
  var text: String
  var isSelected: Bool = false
}
