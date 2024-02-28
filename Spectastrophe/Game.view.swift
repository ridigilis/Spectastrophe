//
//  ContentView.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 1/4/24.
//

import SwiftUI

struct GameView: View {
    @Binding var isPlaying: Bool
    @ObservedObject var game: GameState
    @ObservedObject var encounter: Encounter
    @ObservedObject var player: Pawn

    @State private var currentZoom = 0.0
    @State private var totalZoom = 1.0
    
    @ViewBuilder var HitPointsView: some View {
        GeometryReader { geo in
            HStack {
                Spacer()
                Image("hp-meter")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geo.size.width * 0.9)
                    .overlay(alignment: .trailing) {
                        Rectangle()
                            .frame(width: geo.size.width * 0.7 * (1 - (CGFloat(player.hp > 0 ? player.hp : 0) / CGFloat(player.maxHp))), height: geo.size.height * 0.035, alignment: .trailing)
                            .foregroundStyle(Color.black.opacity(0.4))
                        .offset(x: -8,
                                y: -5)
                        .padding(.leading, 84)
                    }
                    .overlay {
                        Image("hp-frame")
                            .resizable()
                            .scaledToFit()
                            .overlay {
                                HStack {
                                    Text("\(player.hp > 0 ? player.hp : 0)").font(.custom("Trattatello", size: 24))
                                        .bold()
                                        .opacity(0.6)
                                        .offset(x: 28)
                                    Spacer()
                                }
                            }
                    }
                    .padding(.top)
                    .padding(.top)
                Spacer()
            }
            HStack {
                ForEach(1...player.maxOp, id: \.self) { pos in
                    if pos > player.op  {
                        Image("opportunity-empty")
                    } else {
                        Image("opportunity-full")
                    }
                }
            }
            .padding(geo.size.width * 0.2)
            .padding(.leading, geo.size.width * 0.05)
        }
    }

    var body: some View {
        var deck: [any Card] = player.deck.hand + player.deck.drawPile + player.deck.discardPile + player.deck.playArea

        GeometryReader { geometry in
            HStack(alignment: .top) {
                VStack {
                    Image("resources-paper")
                        .resizable()
                        .scaledToFit()
                        .overlay {
                            VStack {
                                HitPointsView
                                
                                Grid(horizontalSpacing: -12,verticalSpacing: -12) {
                                    GearSlotView(gearSlot: .wearable(.head), equipment: player.deck.equipment)
                                    GearSlotView(gearSlot: .wearable(.torso), equipment: player.deck.equipment)
                                    HStack(spacing: -12) {
                                        GearSlotView(gearSlot: .armament(.mainhand), equipment: player.deck.equipment)
                                        GearSlotView(gearSlot: .armament(.offhand), equipment: player.deck.equipment)
                                    }.padding(4)
                                    GearSlotView(gearSlot: .wearable(.hands), equipment: player.deck.equipment)
                                    GearSlotView(gearSlot: .wearable(.feet), equipment: player.deck.equipment)
                                }
                                .offset(y: -geometry.size.height * 0.2)
                                .background {
                                    Image("pawn-player").resizable().scaledToFit().opacity(0.2).offset(y: -geometry.size.height * 0.2)
                                }
                            }
                        }
                        .frame(alignment: .topLeading)
                        .overlay {
                            Image("resources-paper").resizable().scaledToFit().overlay(alignment: .top) {
                                    VStack {
                                        if player.isMovingWith != nil {
                                            Button("CANCEL ACTION") {
                                                withAnimation {
                                                    player.cancelMovementAction()
                                                }
                                            }
                                            .font(.custom("Trattatello", size: 24))
                                            .bold()
                                            .background(Image("label-mid-mythical"))
                                            .padding()
                                            .foregroundStyle(Color.black).opacity(0.8)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                            .disabled(!player.turnToPlay)
                                        } else if player.isAttackingWith != nil {
                                            Button("CANCEL ACTION") {
                                                withAnimation {
                                                    player.cancelAttackAction()
                                                }
                                            }
                                            .font(.custom("Trattatello", size: 24))
                                            .bold()
                                            .background(Image("label-mid-mythical"))
                                            .padding()
                                            
                                            .foregroundStyle(Color.black).opacity(0.8)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                            .disabled(!player.turnToPlay)
                                        } else {
                                            Button(".: END TURN :.") {
                                                withAnimation {
                                                    encounter.onExitPlayPhase()
                                                }
                                            }
                                            .font(.custom("Trattatello", size: 24))
                                            .bold()
                                            .background(Image("label-mid-common"))
                                            .background(Image("label-mid-common"))
                                            .padding()
                                            .foregroundStyle(Color.black).opacity(0.8)
                                            .clipShape(RoundedRectangle(cornerRadius: 18))
                                            .disabled(!player.turnToPlay)
                                        }
                                    }
                                    .padding()
                                    .padding()
                                Spacer()
                            }
                            .offset(y: geometry.size.height * 0.9)
                        }
                    Spacer()
                }
                .frame(width: geometry.size.width * 0.3, height:
                        geometry.size.height * 0.9, alignment: .top)
                
                VStack {
                    Image("map")
                        .resizable()
                        .scaledToFit()
                        .overlay {
                            VStack {
                                ScrollViewReader { proxy in
                                    ScrollView([.horizontal, .vertical], showsIndicators: false) {
                                        BoardView(encounter: encounter, player: player)

                                            .border(.red)
                                    }
                                    .border(.blue)
                                    .defaultScrollAnchor(.center)
//                                    .task {
//                                        withAnimation(.easeInOut) {
//                                            proxy.scrollTo("player", anchor: .center)
//                                            
//                                        }
//                                    }
                                    .onChange(of: player.coords) {
                                        withAnimation(.easeInOut) {
                                            proxy.scrollTo("player", anchor: .center)
                                        }
                                    }
                                    .onTapGesture(count: 2) {
                                        withAnimation(.easeInOut) {
                                            proxy.scrollTo("player", anchor: .center)
                                        }
                                    }
                                }
                            }
                            .padding(.bottom, 80)
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
                            .offset(y: geometry.size.height * 0.1)
                    }
                }
            }
        .overlay {
            if player.hp <= 0 {
                Color(.black)
                    .opacity(0.25)
                    .overlay {
                        VStack {
                            Text("~ Game Over ~")
                                .font(.custom("Trattatello", size: 96))
                                .bold()
                                .background(Color.white.opacity(0.75).blur(radius: 50))
                            Button("Main Menu") {
                                withAnimation {
                                    isPlaying.toggle()
                                    game.newGame()
                                }
                            }
                            .font(.custom("Trattatello", size: 24))
                            .foregroundStyle(Color.black)
                            .background(Image("label-mid-common"))
                        }.background(Color.white.opacity(0.75).blur(radius: 50))
                    }
                    .ignoresSafeArea()
            } else if encounter.enemies.allSatisfy({ $0.hp <= 0 }) {
                Color(.black)
                    .opacity(0.25)
                    .overlay {
                        VStack {
                            Text("~ I guess you win? ~")
                                .font(.custom("Trattatello", size: 96))
                                .bold()
                                .background(Color.white.opacity(0.75).blur(radius: 50))
                            Button("Main Menu") {
                                withAnimation {
                                    isPlaying.toggle()
                                    game.newGame()
                                }
                            }
                            .font(.custom("Trattatello", size: 24))
                            .foregroundStyle(Color.black)
                            .background(Image("label-mid-common"))
                        }.background(Color.white.opacity(0.75).blur(radius: 50))
                    }
                    .ignoresSafeArea()
            } else {
                Color(.clear)
            }
        }
    }
}
