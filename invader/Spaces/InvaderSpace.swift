//
//  InvaderSpace.swift
//  invader
//
//  Created by 三宅武将 on 2023/12/16.
//

import SwiftUI
import RealityKit
import EnemyContent

struct InvaderSpace: View {
    @State private var collisionSubscription: EventSubscription?
    @State private var activationSubscription: EventSubscription?
    
    var collectionEntity = Entity()
    
    var body: some View {
        RealityView { content in
            content.add(spaceOrigin)
            content.add(cameraAnchor)
        }
    }
}

#Preview {
    InvaderSpace()
}

@MainActor
func loadFromRealityComposerPro(named entityName: String) async -> Entity? {
    var entity: Entity? = nil
    do {
        let scene = try await Entity(named: entityName, in: enemyContentBundle)
        entity = scene
    } catch {
        print("Error loading \(entityName)")
    }
    return entity
}
