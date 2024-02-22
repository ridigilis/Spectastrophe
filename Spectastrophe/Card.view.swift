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
    @State private var shadowFill = Color(.sRGBLinear, white: 0, opacity: 0.33)
    @State private var cardDragAmount = CGSize.zero
    @State private var z: Double = 1

    var body: some View {
        VStack {
            if card is GearCard {
                switch card.rarity {
                case .uncommon:
                    Image("cardface-uncommon")
                        .resizable()
                        .scaledToFit()
                case .rare:
                    Image("cardface-rare")
                        .resizable()
                        .scaledToFit()
                case .veryrare:
                    Image("cardface-veryrare")
                        .resizable()
                        .scaledToFit()
                case .legendary:
                    Image("cardface-legendary")
                        .resizable()
                        .scaledToFit()
                case .mythical:
                    Image("cardface-mythical")
                        .resizable()
                        .scaledToFit()
                default:
                    Image("cardface-common")
                        .resizable()
                        .scaledToFit()
                }
            } else {
                Image("cardface-action")
                    .resizable()
                    .scaledToFit()
            }
        }
        .frame(width: 240)
        .overlay(alignment: .center) {
            GeometryReader { geometry in
                    Text(card.title)
                            .font(.custom("Trattatello", size: geometry.size.width * 0.07))
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.18, alignment: .center)
                            .textCase(.uppercase)
                            .lineLimit(1)
                    Text(card.rarity == nil ? "" : card.rarity!.rawValue)
                            .font(.custom("Trattatello", size: geometry.size.width * 0.065))
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.55, alignment: .center)
                            .textCase(/*@START_MENU_TOKEN@*/.uppercase/*@END_MENU_TOKEN@*/)
                    Text(card.description)
                        .font(.custom("Trattatello", size: geometry.size.width * 0.07))
                        .frame(width: geometry.size.width * 0.8, height: geometry.size.height)
                        .padding(.leading, geometry.size.width * 0.1)
            }
            .frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .shadow(color: shadowFill, radius: 24)
        .offset(cardDragAmount)
        .gesture(
            DragGesture()
                .onChanged {
                    z = 2
                    if player.turnToPlay {
                        cardDragAmount = $0.translation
                        if cardDragAmount.height < -200 {
                            cardDragAmount.height = -200
                            cardDragAmount.width = .zero
                            shadowFill = Color.white
                        } else {
                            shadowFill = Color(.sRGBLinear, white: 0, opacity: 0.33)
                        }
                    }
                }
                .onEnded { _ in
                    z = 1
                    if player.turnToPlay && player.isMovingWith == nil && player.isAttackingWith == nil {
                        if cardDragAmount.height == -200 {
                            switch card.primaryAction {
                                case .attack: player.isAttackingWith = card as? ActionCard
                                case .bolster: card.primaryAction!.perform(by: player, on: [player])
                                case .movement: player.isMovingWith = card as? ActionCard
                                case .equip: card.primaryAction!.perform(by: player, on: [player], using: card as? GearCard)
                                default: return
                            }
                            withAnimation {
                                player.deck.playFromHand(card)
                            }
                        } else {
                            shadowFill = Color(.sRGBLinear, white: 0, opacity: 0.33)
                            cardDragAmount = .zero
                        }
                    }
                }
        )
        .animation(.bouncy, value: cardDragAmount)
        .transition(.push(from: .leading))
        .zIndex(z)
        .onLongPressGesture(perform: {
            z = 1
        }, onPressingChanged: { pressing in
            z = pressing ? 2 : 1
        })
    }
}
    
