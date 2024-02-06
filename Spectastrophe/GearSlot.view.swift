//
//  GearSlot.view.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 2/6/24.
//

import SwiftUI

struct GearSlotView: View {
    let gearSlot: Deck.GearSlot
    let gear: GearCard?
    
    var body: some View {
        if gear == nil {
            VStack {
                Text(gearSlot.rawValue).foregroundStyle(Color.gray)
            }
            .frame(width:96, height: 96)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .strokeBorder(.gray, lineWidth: 6)
                    
            )
        } else {
            VStack {
                Text(gear?.title ?? "???").bold()
            }
            .frame(width:96, height: 96)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(.gray)
                    .strokeBorder(.black, lineWidth: 6)
            )
        }
    }
}

#Preview {
    let player = Pawn(.player)
    
    return GearSlotView(gearSlot: .head, gear: player.deck.equipment.head)
}
