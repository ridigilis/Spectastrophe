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
                Grid {
                    GridRow {
                        GearSlotView(gearSlot: .head, equipment: player.deck.equipment)
                    }
                    GridRow {
                        GearSlotView(gearSlot: .torso, equipment: player.deck.equipment)
                    }
                    GridRow {
                        GearSlotView(gearSlot: .hands, equipment: player.deck.equipment)
                    }
                    GridRow {
                        GearSlotView(gearSlot: .feet, equipment: player.deck.equipment)
                    }
                }
            }
            Spacer()
            VStack {
                Spacer()
                if player.isMovingWith != nil {
                    Button("Cancel Action") {
                        player.cancelMovementAction()
                    }
                    .bold()
                    .padding()
                    .background(.red)
                    .foregroundColor(.white.opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                }
                
                if player.isAttackingWith != nil {
                    Button("Cancel Action") {
                        player.cancelAttackAction()
                    }
                    .bold()
                    .padding()
                    .background(.red)
                    .foregroundColor(.white.opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                }
                
                Button("End Turn") {
                    encounter.onExitPlayPhase()
                }
                .bold()
                .padding()
                .background(.green)
                .foregroundColor(.white.opacity(0.8))
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .disabled(!player.turnToPlay)
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
