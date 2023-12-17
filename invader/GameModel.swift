//
//  SwiftUIView.swift
//  invader
//
//  Created by 三宅武将 on 2023/12/16.
//

import SwiftUI
import RealityKit

@Observable
class GameModel {
    static let gameTime = 35
    var timeLeft = gameTime
    var isCountDownReady = false
    var gameState = GameScreen.home
    
    var enemies: [Enemy] = (0..<30).map { Enemy(id: $0, isEnemyDefeated: false)}
    
    init() {
        Task { @MainActor in
            generateEnemyAnimation()
        }
    }
    
    func play() {
        gameState = .play
    }
    
    func planet() {
        gameState = .planet
    }
}


