//
//  ContentView.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 1/4/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var encounter: Encounter
    @ObservedObject var player: Pawn

    @State private var currentZoom = 0.0
    @State private var totalZoom = 1.0

    var body: some View {
        HStack {
            Spacer()
            Spacer()
            Spacer()
            ZStack {
                VStack {
                    BoardView(encounter: encounter, player: player)
                }
                .aspectRatio(contentMode: .fit)
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

                VStack {
                    Spacer()
                    HandView(deck: player.deck, player: player)
                }

                HStack {
                    VStack {
                        Spacer()
                        Grid {
                            GridRow {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 6)
                                        .strokeBorder(.black, lineWidth: 6)
                                        .frame(width:96, height: 96)
                                    
                                    Text("Head")
                                }
                            }
                            GridRow {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 6)
                                        .strokeBorder(.black, lineWidth: 6)
                                        .frame(width:96, height: 96)
                                    
                                    Text("Torso")
                                }
                            }
                            GridRow {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 6)
                                        .strokeBorder(.black, lineWidth: 6)
                                        .frame(width:96, height: 96)
                                    
                                    Text("Hands")
                                }
                            }
                            GridRow {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 6)
                                        .strokeBorder(.black, lineWidth: 6)
                                        .frame(width:96, height: 96)
                                    
                                    Text("Feet")
                                }
                            }
                        }
                    }
                    Spacer()
                    VStack {
                        Spacer()
                        if player.isMovingWith != nil {
                            Button("Cancel Action") {
                                player.cancelMovementAction()
                            }
                            .bold()
                            .padding()
                            .background(.red)
                            .foregroundColor(.white.opacity(0.8))
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        }

                        if player.isAttackingWith != nil {
                            Button("Cancel Action") {
                                player.cancelAttackAction()
                            }
                            .bold()
                            .padding()
                            .background(.red)
                            .foregroundColor(.white.opacity(0.8))
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        }
                        
                        Button("End Turn") {
                            encounter.onExitPlayPhase()
                        }
                        .bold()
                        .padding()
                        .background(.green)
                        .foregroundColor(.white.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .disabled(!player.turnToPlay)
                    }
                }
                .padding(24)
            }

            Spacer()
        }
    }
}

#Preview {
    let player = Pawn(.player)
    let world = [Coords: Encounter]()
    let location = Coords(0,0)
    let game: GameState = GameState(player: player, world: world, location: location)
    
    return ContentView(encounter: game.world[game.location]!, player: game.player)
}
