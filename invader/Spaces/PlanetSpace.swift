//
//  PlatnetSpace.swift
//  invader
//
//  Created by 三宅武将 on 2023/12/17.
//

import SwiftUI
import RealityKit
import EnemyContent

struct PlanetSpace: View {
    var body: some View {
        RealityView { content in
            content.add(spaceOrigin)
            content.add(cameraAnchor)
            
            guard let resource = try? TextureResource.load(named: "star") else {
                fatalError("Unable to load starfield texture")
            }
            var material = UnlitMaterial()
            material.color = .init(texture: .init(resource))
            
            // マテリアルを大きな球体に取り付ける
            let entity = Entity()
            entity.components.set(ModelComponent(
                mesh: .generateSphere(radius: 1000), materials: [material]
            ))
            entity.scale *= .init(x: -10, y: 10, z: 10)
            
            content.add(entity)
            
            guard let planets = await loadFromRealityComposerPro(named: "Planet.usda"),
                  let white = try? await EnvironmentResource(named: "white")
            else {
                fatalError("ERROR")
            }
            let imageLight = ImageBasedLightComponent(source: .single(white), intensityExponent: 0.5)
            planets.components.set(InputTargetComponent())
            planets.components.set(CollisionComponent(shapes: [ShapeResource.generateBox(size: SIMD3<Float>(repeating: 0.3))]))
            planets.components.set(imageLight)
            planets.components.set(ImageBasedLightReceiverComponent(imageBasedLight: planets))
            
            content.add(planets)
        }
    }
}

#Preview {
    PlanetSpace()
}
