//
//  ContentView.swift
//  invader
//
//  Created by 三宅武将 on 2024/04/27.
//

import SwiftUI

struct ContentView: View {
    @Environment(AppState.self) private var appState
    
    var body: some View {
        @Bindable var appState = appState
        switch appState.phase {
        case .startingUp:
            Text("startingUp")
        case .loadingAssets:
            VStack {
                Text("Assets Loadign...")
                
                ProgressView()
                    .scaleEffect(x: 2, y: 2)
                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
                    .padding(.top, 12)
            }
        case .watingToStart:
            Button(action: {
                appState.startPlaying()
            }, label: {
                Text("Game Start")
            })
        case .playing:
            Text("playing")
        case .result:
            Text("result")
        }
    }
}

#Preview {
    ContentView()
        .environment(AppState())
}
