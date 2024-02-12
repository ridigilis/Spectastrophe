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
                        GearSlotView(gearSlot: .mainhand, equipment: player.deck.equipment)
                        GearSlotView(gearSlot: .offhand, equipment: player.deck.equipment)
                    }
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
                        withAnimation {
                            player.cancelMovementAction()
                        }
                    }
                    .bold()
                    .padding()
                    .background(.red)
                    .foregroundColor(.white.opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                } else if player.isAttackingWith != nil {
                    Button("Cancel Action") {
                        withAnimation {
                            player.cancelAttackAction()
                        }
                    }
                    .bold()
                    .padding()
                    .background(.red)
                    .foregroundColor(.white.opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                } else {
                    Button("End Turn") {
                        withAnimation {
                            encounter.onExitPlayPhase()
                        }
                    }
                    .bold()
                    .padding()
                    .background(.green)
                    .foregroundColor(.white.opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .disabled(!player.turnToPlay)
                }
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
