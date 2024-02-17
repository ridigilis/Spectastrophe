//
//  MainMenu.view.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 2/7/24.
//

import SwiftUI

struct MainMenuView: View {
    @Binding var isPlaying: Bool
    
    var body: some View {
        VStack {
            Text("Spectastrophe.")
                .font(.custom("Trattatello", size: 120))
                .padding(.bottom, 60)
            Button("START NEW PLAYTEST") {
                isPlaying.toggle()
            }
            .font(.custom("Trattatello", size: 24))
        }
    }
}

#Preview {
    @State var isPlaying: Bool = false
    return MainMenuView(isPlaying: $isPlaying)
}
