//
//  Invader.swift
//  invader
//
//  Created by 三宅武将 on 2023/12/16.
//

import SwiftUI

struct Invader: View {
    @Environment(GameModel.self) var gameModel
    
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Spacer()
            Group {
                switch gameModel.gameState {
                case .home:
                    Home()
                case .play:
                    Play()
                case .planet:
                    PlanetView()
                }
            }
            .glassBackgroundEffect(
                in: RoundedRectangle(
                    cornerRadius: 32,
                    style: .continuous
                )
            )
        }
        .onReceive(timer) { _ in
            if gameModel.gameState == .play && gameModel.timeLeft > 0 {
                gameModel.timeLeft -= 1
                // 5秒ごとに3対の敵キャラを生成
                if (gameModel.timeLeft % 3 == 0 || GameModel.gameTime == GameModel.gameTime - 1) && gameModel.timeLeft > 4 {
                    Task { @MainActor () -> Void in
                        do {
                            let spawnAmount = 3
                            for _ in 0..<spawnAmount {
                                _ = try await spawnEnemy()
                                try await Task.sleep(for: .milliseconds(300))
                            }
                            postEnemyOverviewAnnouncement(gameModel: gameModel)
                        } catch {
                            print("ERROR!!!! \(error)")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    Invader()
}

enum GameScreen {
    case home
    case play
    case planet
}
