//
//  invaderApp.swift
//  invader
//
//  Created by 三宅武将 on 2023/12/16.
//

import SwiftUI
import RealityKit

@main
struct invaderApp: App {
    @State private var gameModel = GameModel()
    @State private var immersionState: ImmersionStyle = .mixed
    
    var body: some SwiftUI.Scene {
        WindowGroup {
            Invader()
                .environment(gameModel)
                .onAppear {
                    guard let windowScreen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                        return
                    }
                    
                    windowScreen.requestGeometryUpdate(.Vision(resizingRestrictions: UIWindowScene.ResizingRestrictions.none))
                }
        }
        .windowStyle(.plain)

        // FullSpaceにしたさいに呼ばれる
        ImmersiveSpace(id: "invader") {
            InvaderSpace()
        }
        
        ImmersiveSpace(id: "planet") {
            PlanetSpace()
        }
        .immersionStyle(selection: $immersionState, in: .mixed)
    }
}
