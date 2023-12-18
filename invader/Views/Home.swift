//
//  Start.swift
//  invader
//
//  Created by 三宅武将 on 2023/12/16.
//

import SwiftUI
import RealityKit

struct Home: View {
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(GameModel.self) var gameModel
    
    var body: some View {
        HStack {
            RealityView { content in
                guard let skull = try? await ModelEntity(named: "Skull.usdz"),
                      let resource = try? await EnvironmentResource(named: "whiteLighting")
                else {
                    fatalError("ERROR")
                }
                let imageLight = ImageBasedLightComponent(source: .single(resource), intensityExponent: 1.0)
                skull.components.set(InputTargetComponent())
                skull.components.set(CollisionComponent(shapes: [ShapeResource.generateBox(size: SIMD3<Float>(repeating: 0.3))]))
                skull.components.set(imageLight)
                skull.components.set(ImageBasedLightReceiverComponent(imageBasedLight: skull))
                content.add(skull)
                skull.position = SIMD3<Float>(x: skull.position.x, y: skull.position.y - 0.11, z: skull.position.z)
            }
            .gesture(
                SpatialEventGesture()
                    .targetedToAnyEntity()
                    .onEnded { _ in
                        Task {
                            await openImmersiveSpace(id: "invader")
                            gameModel.play()
                        }
                    }
            )
            
            RealityView { content in
                guard let sun = try? await ModelEntity(named: "Sun.usdz"),
                      let resource = try? await EnvironmentResource(named: "whiteLighting")
                else {
                    fatalError("ERROR")
                }
                let imageLight = ImageBasedLightComponent(source: .single(resource), intensityExponent: 0.5)
                sun.components.set(InputTargetComponent())
                sun.components.set(CollisionComponent(shapes: [ShapeResource.generateBox(size: SIMD3<Float>(repeating: 0.1))]))
                sun.components.set(imageLight)
                sun.components.set(ImageBasedLightReceiverComponent(imageBasedLight: sun))

                
                content.add(sun)
            }
            .gesture(
                SpatialEventGesture()
                    .targetedToAnyEntity()
                    .onEnded { _ in
                        Task {
                            await openImmersiveSpace(id: "planet")
                            gameModel.planet()
                        }
                    }
            )
            
        }
        .padding([.leading, .trailing], 150)
    }
}

#Preview {
    Home()
}
