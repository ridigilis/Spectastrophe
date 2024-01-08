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
    @State private var currentZoom = 0.0
    @State private var totalZoom = 1.0

    var body: some View {
        HStack {
            Spacer()
            Spacer()
            Spacer()
            ZStack {
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
                .scaleEffect(currentZoom + totalZoom)
                .gesture(
                    MagnifyGesture()
                        .onChanged { value in
                            currentZoom = value.magnification - 1
                        }
                        .onEnded { value in
                            totalZoom += currentZoom
                            currentZoom = 0
                        }
                )
                .accessibilityZoomAction { action in
                    if action.direction == .zoomIn {
                        totalZoom += 1
                    } else {
                        totalZoom -= 1
                    }
                }

                VStack {
                    Spacer()
                    HStack {
                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                            .frame(width:120, height: 180)
                            .foregroundColor(.brown)
                            .shadow(radius: 12)

                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                            .frame(width:120, height: 180)
                            .foregroundColor(.brown)
                            .shadow(radius: 12)

                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                            .frame(width:120, height: 180)
                            .foregroundColor(.brown)
                            .shadow(radius: 12)
                    }
                }
            }

            Spacer()
        }
    }
}

#Preview {
    ContentView()
}
