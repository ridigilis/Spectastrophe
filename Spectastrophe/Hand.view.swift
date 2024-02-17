//
//  HandView.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 1/14/24.
//

import SwiftUI

struct HandView: View {
    @ObservedObject var deck: Deck
    @ObservedObject var player: Pawn

    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack(spacing: -(geometry.size.width * 0.025 * CGFloat(deck.hand.count))) {
                    ForEach(deck.hand, id: \.self.id) { card in
                        CardView(card: card, player: player)
                    }
                }
                .frame(maxWidth: geometry.size.width)
            }.frame(height: geometry.size.height, alignment: .bottom)
        }

    }
}

#Preview {
    let deck = Deck()
    let player = Pawn(.player)

    return HandView(deck: deck, player: player)
}
