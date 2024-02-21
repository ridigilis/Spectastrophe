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
        case .wearable(.head): equipment.head
        case .wearable(.torso): equipment.torso
        case .wearable(.feet): equipment.feet
        case .wearable(.hands): equipment.hands
        case .armament(.mainhand): equipment.mainhand
        case .armament(.offhand): equipment.offhand
        }
        
        let label = switch gearSlot {
        case let .wearable(slot): slot.rawValue
        case let .armament(slot): slot.rawValue
        }
        
        if gear == nil {
            VStack {
                Image("label-mid-generic")
                    .resizable()
                    .scaledToFit()
            }
            .overlay {
                Text("\(label) (empty)").font(.custom("Trattatello", size: 16))
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
    
    return GearSlotView(gearSlot: .wearable(.head), equipment: player.deck.equipment)
}
