//
//  AppState.swift
//  invader
//
//  Created by 三宅武将 on 2024/04/28.
//

import Foundation
import ARKit
import RealityKit
import RealityKitContent
import SwiftUI

public struct LoadEnemy {
    var entityName: String
    var entityLevel: EnemyLevel
}

@Observable
@MainActor
public class AppState {
    var phase: AppPhase = .startingUp
    
    var session: ARKitSession = ARKitSession()
    var worldInfo = WorldTrackingProvider()
    
    public let loadEnemies: [LoadEnemy] = [
        LoadEnemy(entityName: basicEnemy, entityLevel: .basic),
        LoadEnemy(entityName: intermediateEnemy, entityLevel: .intermediate),
        LoadEnemy(entityName: advancedEnemy, entityLevel: .advanced),
        LoadEnemy(entityName: eliteEnemy, entityLevel: .elite),
        LoadEnemy(entityName: legendaryEnemy, entityLevel: .legendary)
    ]
    
    private let cameraEntity: ModelEntity = .init(mesh: .generateSphere(radius: 0.05),
                                                  materials: [SimpleMaterial(color: .blue, isMetallic: false)],
                                                  collisionShapes: [.generateSphere(radius: 0.05)],
                                                  mass: 0.0)
    
    var root = Entity()
    var enemies: [Entity] = []
    
    init() {
        cameraEntity.components.set(CameraComponent())
        cameraEntity.components.set(OpacityComponent(opacity: 0.0))
        root.addChild(cameraEntity)
        
        Task.detached(priority: .high) {
            do {
                try await self.session.run([self.worldInfo])
            } catch {
                fatalError("Error running World Tracking Provider: \(error.localizedDescription)")
            }
            await self.loadEnemyEntities()
        }
    }
}
