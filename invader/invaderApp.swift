//
//  invaderApp.swift
//  invader
//
//  Created by 三宅武将 on 2024/04/27.
//

import SwiftUI
import RealityKitContent

@main
@MainActor
struct invaderApp: App {
    @Environment(\.openImmersiveSpace) private var openImmsersiveSpace
    
    @State private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appState)
                .onChange(of: appState.phase.isImmersed) { _, showMRView in
                    if showMRView {
                        Task {
                            await openImmsersiveSpace(id: "PlaySpace")
                        }
                    }
                }
        }
        .windowStyle(.automatic)
//        .windowResizability(.contentSize)
//
//        ImmersiveSpace(id: "ImmersiveSpace") {
//            ImmersiveView()
//        }
        
        ImmersiveSpace(id: "PlaySpace") {
            PlayImmsersiveView()
                .environment(appState)
        }
    }
    init() {
        CameraSystem.registerSystem()
        CameraComponent.registerComponent()
        
        EnemySystem.registerSystem()
        EnemyComponent.registerComponent()
    }
}
