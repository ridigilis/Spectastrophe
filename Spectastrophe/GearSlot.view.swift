//
//  GearSlot.view.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 2/6/24.
//

import SwiftUI

struct GearSlotView: View {
    let gearSlot: Deck.GearSlot
    @ObservedObject var equipment: Deck.Equipment
    
    var body: some View {
        let gear: GearCard? = switch gearSlot {
        case .head: equipment.head
        case .torso: equipment.torso
        case .feet: equipment.feet
        case .hands: equipment.hands
        }
        
        if gear == nil {
            VStack {
                Text("\(gearSlot.rawValue) (empty)").foregroundStyle(Color.gray).font(.footnote)
            }
            .frame(width:96, height: 96)
            .background {
                Image("gearslot-empty")
                    .resizable()
                    .scaledToFit()
            }
        } else {
            VStack {
                Text(gear?.title ?? "???").bold().font(.footnote)
            }
            .frame(width:96, height: 96)
            .background {
                switch gear!.rarity {
                case .common:
                    Image("gearslot-common")
                        .resizable()
                        .scaledToFit()
                case .uncommon:
                    Image("gearslot-uncommon")
                        .resizable()
                        .scaledToFit()
                case .rare:
                    Image("gearslot-rare")
                        .resizable()
                        .scaledToFit()
                case .veryrare:
                    Image("gearslot-veryrare")
                        .resizable()
                        .scaledToFit()
                case .legendary:
                    Image("gearslot-legendary")
                        .resizable()
                        .scaledToFit()
                case .mythical:
                    Image("gearslot-mythical")
                        .resizable()
                        .scaledToFit()
                default:
                    Image("gearslot-empty")
                        .resizable()
                        .scaledToFit()
                }
            }
        }
    }
}

#Preview {
    let player = Pawn(.player)
    
    return GearSlotView(gearSlot: .head, equipment: player.deck.equipment)
}
