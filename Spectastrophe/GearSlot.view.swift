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
        case .mainhand: equipment.mainhand
        case .offhand: equipment.offhand
        }
        
        if gear == nil {
            VStack {
                Image("label-mid-generic")
                    .resizable()
                    .scaledToFit()
            }
            .overlay {
                Text("\(gearSlot.rawValue) (empty)").font(.custom("Trattatello", size: 16))
            }
        } else {
            VStack {
                switch gear!.rarity {
                case .common:
                    Image("label-mid-common")
                        .resizable()
                        .scaledToFit()
                case .uncommon:
                    Image("label-mid-uncommon")
                        .resizable()
                        .scaledToFit()
                case .rare:
                    Image("label-mid-rare")
                        .resizable()
                        .scaledToFit()
                case .veryrare:
                    Image("label-mid-veryrare")
                        .resizable()
                        .scaledToFit()
                case .legendary:
                    Image("label-mid-legendary")
                        .resizable()
                        .scaledToFit()
                case .mythical:
                    Image("label-mid-mythical")
                        .resizable()
                        .scaledToFit()
                default:
                    Image("label-mid-generic")
                        .resizable()
                        .scaledToFit()
                }
            }
            .overlay {
                Text(gear?.title ?? "???").bold().font(.custom("Trattatello", size: 16)).textCase(.uppercase)
            }
        }
    }
}

#Preview {
    let player = Pawn(.player)
    
    return GearSlotView(gearSlot: .head, equipment: player.deck.equipment)
}
