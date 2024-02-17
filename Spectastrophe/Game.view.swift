//
//  ContentView.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 1/4/24.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var encounter: Encounter
    @ObservedObject var player: Pawn

    @State private var currentZoom = 0.0
    @State private var totalZoom = 1.0
    
    @ViewBuilder var HitPointsView: some View {
        GeometryReader { geo in
            VStack {
                    Image("hp-meter")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width * 0.8)
                        .overlay(alignment: .trailing) {
                            Rectangle()
                                .frame(width: geo.size.width * 0.65 * (1 - (CGFloat(player.hp > 0 ? player.hp : 0) / CGFloat(player.maxHp))), height: geo.size.height * 0.015, alignment: .trailing)
                                .foregroundStyle(Color.black.opacity(0.35))
                            .offset(x: -8,
                                    y: -5)
                        }
                        .overlay {
                            Image("hp-frame")
                                .resizable()
                                .scaledToFit()
                        }
            }
            .padding()
            .padding()
            .padding(.top)
            .padding(.top)
            .padding(.trailing)
        
        }
    }

    var body: some View {
        GeometryReader { geometry in
            HStack {
                VStack {
                    Image("resources-paper")
                        .resizable()
                        .scaledToFill()
                        .frame(alignment: .topLeading)
                        .overlay {
                            HitPointsView
                            Grid(horizontalSpacing: -24, verticalSpacing: -24) {
                                GridRow {
                                    GearSlotView(gearSlot: .head, equipment: player.deck.equipment)
                                    GearSlotView(gearSlot: .torso, equipment: player.deck.equipment)
                                }
                                
                                GridRow {
                                    GearSlotView(gearSlot: .mainhand, equipment: player.deck.equipment)
                                    GearSlotView(gearSlot: .offhand, equipment: player.deck.equipment)
                                }

                                GridRow {
                                    GearSlotView(gearSlot: .hands, equipment: player.deck.equipment)
                                    GearSlotView(gearSlot: .feet, equipment: player.deck.equipment)
                                }
                            }
                            .padding()
                            .padding()
                            .padding()
                            Spacer()
                        }
                        .frame(alignment: .topLeading)
                    Spacer()
                }
                .frame(width: geometry.size.width * 0.4, height: geometry.size.height * 0.8)
                Spacer()
                VStack {
                    Image("map")
                        .resizable()
                        .scaledToFit()
                        .overlay {
                            VStack {
                                ScrollView([.horizontal, .vertical], showsIndicators: false) {
                                    BoardView(encounter: encounter, player: player)
                                        .scaleEffect(currentZoom + totalZoom)
                                        .gesture(
                                            MagnifyGesture()
                                                .onChanged { value in
                                                    currentZoom = value.magnification - 1
                                                }
                                                .onEnded { value in
                                                    totalZoom += currentZoom
                                                    currentZoom = 0
                                                }
                                        )
                                        .accessibilityZoomAction { action in
                                            if action.direction == .zoomIn {
                                                totalZoom += 1
                                            } else {
                                                totalZoom -= 1
                                            }
                                        }
                                }
                                .defaultScrollAnchor(.center)
                            }
                            .padding(.bottom, 80)
                            .padding(.top, 60)
                            .padding(.horizontal, 80)
                            .mask(LinearGradient(gradient: Gradient(colors: [.clear, .clear,.clear, .black,.black,.black,.black,.black,.black, .black,.black,.black,.black,.clear,.clear, .clear]), startPoint: .leading, endPoint: .trailing))
                            .mask(LinearGradient(gradient: Gradient(colors: [.clear, .clear,.clear, .black,.black,.black,.black,.black,.black,.black,.black,.clear,.clear, .clear]), startPoint: .bottom, endPoint: .top))
                            .mask(Image("mapmask").resizable().scaledToFit())
                            .mask(Image("mapmask").resizable().scaledToFit())
                            .mask(Image("mapmask").resizable().scaledToFit())
                            .mask(Image("mapmask").resizable().scaledToFit())
                        }
                    Spacer()
                    }
                .overlay {
                        HUDView(encounter: encounter, player: player)
                    }
                }
            }
        .overlay {
            if player.hp <= 0 {
                Color(.black)
                    .opacity(0.25)
                    .overlay {
                        VStack {
                            Text("Game Over")
                                .font(.largeTitle)
                                .bold()
                            Button("New Game") {
                                // TODO: start a new game
                            }
                        }
                    }
                    .ignoresSafeArea()
            }
        }
    }
}

#Preview {
    let player = Pawn(.player)
    let world = [Coords: Encounter]()
    let location = Coords(0,0)
    let game: GameState = GameState(player: player, world: world, location: location)
    
    return GameView(encounter: game.world[game.location] ?? Encounter(Coords(0,0), player: player), player: game.player)

}
