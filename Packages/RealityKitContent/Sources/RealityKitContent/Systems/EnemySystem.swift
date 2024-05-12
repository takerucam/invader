//
//  File.swift
//  
//
//  Created by 三宅武将 on 2024/05/12.
//

import Foundation
import RealityKit
import SwiftUI

public struct EnemySystem: System {
    
    static let query = EntityQuery(where: .has(EnemyComponent.self))
    
    public init(scene: RealityKit.Scene) {
    }
    
    public func update(context: SceneUpdateContext) {
        
        let entities = context.scene.performQuery(Self.query).map({ $0 })
        guard let cameraPosition = context.scene.performQuery(CameraSystem.query).map({ $0 }).first?.transform.translation
        else { return }
        
        for entity in entities {
            entity.transform.translation.y = cameraPosition.y
            entity.transform.translation.z = cameraPosition.z
            
            entity.transform.translation.z -= 2
        }
    }
}
