//
//  invaderApp.swift
//  invader
//
//  Created by 三宅武将 on 2024/04/27.
//

import SwiftUI

@main
struct invaderApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}
