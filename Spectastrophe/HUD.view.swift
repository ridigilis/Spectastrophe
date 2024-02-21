//
//  HUD.view.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 2/3/24.
//

import SwiftUI

struct HUDView: View {
    @ObservedObject var encounter: Encounter
    @ObservedObject var player: Pawn
    
    var body: some View {
        HStack {
            VStack {
                Spacer()
            }
            Spacer()
            VStack {
                Spacer()

            }
        }
        .padding(24)
        
        VStack {
            Spacer()
            HandView(deck: player.deck, player: player)
        }
    }
}

#Preview {
    let player = Pawn(.player)
    let world = [Coords: Encounter]()
    let location = Coords(0,0)
    let game: GameState = GameState(player: player, world: world, location: location)
    
    return HUDView(encounter: game.world[game.location] ?? Encounter(Coords(0,0), player: player), player: game.player)
}
