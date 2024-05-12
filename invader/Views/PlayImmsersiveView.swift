//
//  PlayImmsersiveView.swift
//  invader
//
//  Created by 三宅武将 on 2024/04/29.
//

import SwiftUI
import RealityKit

struct PlayImmsersiveView: View {
    @Environment(AppState.self) private var appState
    
    var body: some View {
        RealityView { content in
            content.add(appState.root)
        }
        .onAppear {
            appState.addEnemiesToScene()
        }
    }
}

#Preview {
    PlayImmsersiveView()
        .environment(AppState())
}
