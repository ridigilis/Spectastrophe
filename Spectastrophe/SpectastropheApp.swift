//
//  SpectastropheApp.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 1/4/24.
//

import SwiftUI

@main
struct SpectastropheApp: App {
    @State private var isPlaying = false
    @StateObject var game: GameState = GameState()
    
    var body: some Scene {
        WindowGroup {
            if !isPlaying {
                MainMenuView(isPlaying: $isPlaying)
                    .onChange(of: isPlaying) {
                        if isPlaying == true {
                            game.newGame()
                        }
                    }
            } else {
                GameView(isPlaying: $isPlaying, game: game, encounter: game.world[game.location]!, player: game.player)
                .background {
                    Image("tabletop").resizable().scaledToFill().ignoresSafeArea()
                }
                
            }
        }
    }
}
