//
//  ContentView.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 1/4/24.
//

import SwiftUI

struct BoardView: View {
    var tiles: BoardMap

    var body: some View {
        ForEach(Range(-6...6)) { row in
            HStack {
                ForEach(tiles.filter { $0.key.y == row }.map { Coords($0.value!.id.x * -1, $0.value!.id.y * -1) }.sorted(by: { $0.x < $1.x }), id:\.self) { tile in
                    Spacer().frame(width: 4)
                    Circle().fill(.gray).padding(-4)
                    Spacer().frame(width: 8)
                }
            }
        }
    }
}

struct ContentView: View {
    @StateObject private var game: GameState = GameState()
    @State private var currentZoom = 0.0
    @State private var totalZoom = 1.0

    var body: some View {
        HStack {
            Spacer()
            Spacer()
            Spacer()
            ZStack {
                VStack {
                    BoardView(tiles: game.world.encounter.board.tiles)
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
