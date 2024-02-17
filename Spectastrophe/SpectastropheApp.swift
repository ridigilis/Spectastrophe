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
    @StateObject var game: GameState = GameState(
        player: Pawn(.player, maxHp: 60, tile: Coords(0,0), deck: Deck(drawPile: [
            LootMachine().gimme(slot: .head),
            LootMachine().gimme(slot: .torso),
            LootMachine().gimme(slot: .hands),
            LootMachine().gimme(slot: .feet),
            LootMachine().gimme(),
            LootMachine().gimme(),
            LootMachine().gimme(),
            LootMachine().gimme(),
            ActionCard(title: "Move", description: "Move to an adjacent space", action: .movement(for: .constant(1))),
            ActionCard(title: "Move", description: "Move to an adjacent space", action: .movement(for: .constant(1))),
        ])),
        world: [Coords: Encounter](),
        location: Coords(0,0)
    )
    
    var body: some Scene {
        WindowGroup {
            if !isPlaying {
                MainMenuView(isPlaying: $isPlaying)
            } else {
                GameView(encounter: Encounter(game.location, enemies: [
                    Pawn(.enemy, maxHp: 24, tile: Coords(-3, 6), deck: Deck(drawPile: [
                        ActionCard(title: "Move", description: "Move to an adjacent space", action: .movement(for: .constant(1))),
                        ActionCard(title: "Move", description: "Move to an adjacent space", action: .movement(for: .constant(1))),
                        LootMachine().gimme(slot: .head),
                        LootMachine().gimme(slot: .torso),
                        LootMachine().gimme(slot: .hands),
                        LootMachine().gimme(slot: .feet),
                        LootMachine().gimme(),
                        LootMachine().gimme(),
                        LootMachine().gimme(),
                        LootMachine().gimme(),
                    ])),
                    Pawn(.enemy, maxHp: 24, tile: Coords(2, 4), deck: Deck(drawPile: [
                        ActionCard(title: "Move", description: "Move to an adjacent space", action: .movement(for: .constant(1))),
                        ActionCard(title: "Move", description: "Move to an adjacent space", action: .movement(for: .constant(1))),
                        LootMachine().gimme(slot: .head),
                        LootMachine().gimme(slot: .torso),
                        LootMachine().gimme(slot: .hands),
                        LootMachine().gimme(slot: .feet),
                        LootMachine().gimme(),
                        LootMachine().gimme(),
                        LootMachine().gimme(),
                        LootMachine().gimme(),
                    ])),
                    Pawn(.enemy, maxHp: 24, tile: Coords(0, -4), deck: Deck(drawPile: [
                        ActionCard(title: "Move", description: "Move to an adjacent space", action: .movement(for: .constant(1))),
                        ActionCard(title: "Move", description: "Move to an adjacent space", action: .movement(for: .constant(1))),
                        LootMachine().gimme(slot: .head),
                        LootMachine().gimme(slot: .torso),
                        LootMachine().gimme(slot: .hands),
                        LootMachine().gimme(slot: .feet),
                        LootMachine().gimme(),
                        LootMachine().gimme(),
                        LootMachine().gimme(),
                        LootMachine().gimme(),
                    ])),
                ], player: game.player), player: game.player)
                .background {
                    Image("tabletop").resizable().scaledToFill().ignoresSafeArea()
                }
            }
        }
    }
}
