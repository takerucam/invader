//
//  AppState+EnemyLoading.swift
//  invader
//
//  Created by 三宅武将 on 2024/04/28.
//

import Foundation
import RealityKit
import RealityKitContent

actor EntityContainer {
    var entity: Entity?
    func setEntity(_ newEntity: Entity?) {
        entity = newEntity
    }
}

public enum EnemyLevel {
    case basic
    case intermediate
    case advanced
    case elite
    case legendary
}

struct LoadResult {
    var entity: Entity
    var enemyLevel: EnemyLevel
}

extension AppState {
    /// Reality Composer Proから任意のSceneから任意のEntityを読み込む
    private func loadFromRCPro(named entityName: String,
                               fromSceneNamed sceneName: String,
                               scaleFactor: Float? = nil) async throws -> Entity? {
        var ret: Entity?
        do {
            let scene = try await Entity(named: sceneName, in: realityKitContentBundle)
            let entityContainer = EntityContainer()
            let enemyEntity = scene.findEntity(named: entityName)
            if let scaleFactor = scaleFactor {
                enemyEntity?.scale = SIMD3<Float>(repeating: scaleFactor)
            }
            await entityContainer.setEntity(enemyEntity)
            ret = await entityContainer.entity
        } catch {
            fatalError("\tEncountered fatal error: \(error.localizedDescription)")
        }
        return ret
    }
    
    public func loadEnemyEntities() async {
        defer {
            finishedLoadingAssets()
        }
        finishedStartingUp()
        await withTaskGroup(of: LoadResult.self) { taskGroup in
            loadEnemy(taskGroup: &taskGroup)
            for await result in taskGroup {
                self.enemies.append(result.entity)
            }
        }
    }
    
    private func loadEnemy(taskGroup: inout TaskGroup<LoadResult>) {
        for enemy in loadEnemies {
            taskGroup.addTask {
                do {
                    guard let entity = try await self.loadFromRCPro(named: enemy.entityName, fromSceneNamed: enemyScene)
                    else {
                        fatalError("Attempted to load enemy entity \(enemy) but failed.")
                    }
                    
                    await entity.components.set(EnemyComponent())
                    
                    return LoadResult(entity: entity, enemyLevel: enemy.entityLevel)
                } catch {
                    fatalError()
                }
            }
        }
    }
}
