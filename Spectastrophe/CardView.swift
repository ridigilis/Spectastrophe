//
//  CardView.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 1/14/24.
//

import SwiftUI

struct CardView: View {
    var card: any Card
    @ObservedObject var player: Pawn

    @State private var fill = Color.brown

    @State private var dragAmount = CGSize.zero

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0)
                .fill(fill)
                .frame(width:120, height: 180)
                .shadow(radius: 12)
            VStack {
                Text(card.title)
                    .frame(alignment: .topLeading)
                    .bold()
                    .padding(.bottom)
                    .padding(.bottom)

                Text(card.description)
                    .font(.footnote)
                    .padding(.bottom)
                    .padding(.bottom)
            }
        }
        .offset(dragAmount)
        .gesture(
            DragGesture()
                .onChanged {
                    if player.turnToPlay {
                        dragAmount = $0.translation
                        if dragAmount.height < -200 {
                            fill = Color.teal
                        } else {
                            fill = Color.brown
                        }
                    }
                }
                .onEnded { _ in
                    if player.turnToPlay {
                        if dragAmount.height < -200 {
                            switch card.action {
                                case .attack:
                                    player.isAttacking.toggle()
                                    player.isAttackingWith = card.action
                                case .movement: card.action.perform(by: player, on: [player])
                                case .equip: card.action.perform(by: player, on: [player], using: card as? GearCard)
                                default: return
                            }
                            player.deck.playFromHand(card)
                        }

                        fill = Color.brown
                        dragAmount = .zero
                    }
                }
        )
        .animation(.bouncy, value: dragAmount)
    }
}

#Preview {
    let card = ActionCard(action: .attack(.physical(.bludgeon), for: .constant(1)))
    let player = Pawn(.player)
    
    return CardView(card: card, player: player)
}
