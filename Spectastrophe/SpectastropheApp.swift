//
//  SpectastropheApp.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 1/4/24.
//

import SwiftUI

@main
struct SpectastropheApp: App {
    @StateObject var game: GameState = GameState(
        player: Pawn(.player, maxHp: 120, tile: Coords(0,0), deck: Deck(drawPile: [
            GearCard(slot: .hands, title: "Legendary Warhammer", description: "Adds 1 Bludgeon", cards: [
                ActionCard(title: "Bludgeon", description: "Attack an adjacent enemy for 1d100", action: .attack(.physical(.bludgeon), for: .random([.d100])))
            ])
        ])),
        world: [Coords: Encounter](),
        location: Coords(0,0)
    )
    var body: some Scene {
        WindowGroup {
            GameView(encounter: Encounter(game.location, enemies: [Pawn(.enemy, maxHp: 60, tile: Coords(-3, 6))], player: game.player), player: game.player)
        }
    }
}
