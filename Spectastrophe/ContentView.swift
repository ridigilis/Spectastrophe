//
//  ContentView.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 1/4/24.
//

import SwiftUI

struct Row: View {
    var count: Int

    init(_ count: Int = 0) {
        self.count = count
    }

    var body: some View {
        HStack {
            ForEach(Range(0...count)) { _ in
                Spacer().frame(width: 4)
                Circle().fill(.gray).padding(-4)
                Spacer().frame(width: 8)
            }
        }.padding(-4)
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Row(6)
            Row(7)
            Row(8)
            Row(9)
            Row(10)
            Row(11)
            Row(12)
            Row(11)
            Row(10)
            Row(9)
            Row(8)
            Row(7)
            Row(6)
        }
        .aspectRatio(contentMode: .fit)
    }
}

#Preview {
    ContentView()
}
