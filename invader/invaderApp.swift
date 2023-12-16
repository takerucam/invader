//
//  invaderApp.swift
//  invader
//
//  Created by 三宅武将 on 2023/12/16.
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
        }.immersionStyle(selection: .constant(.full), in: .full)
    }
}
