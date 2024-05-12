//
//  File.swift
//  
//
//  Created by 三宅武将 on 2024/05/12.
//

import Foundation
import RealityKit
import ARKit
import SwiftUI

public struct CameraSystem: System {
    static let query = EntityQuery(where: .has(CameraComponent.self))
    static public var dependencies: [SystemDependency] {
        [.after(CameraSystem.self)]
    }
    
    private let arkitSession = ARKitSession()
    private let worldTrackingProvider = WorldTrackingProvider()
    
    public init(scene: RealityKit.Scene) {
        setUpSession()
    }
    
    func setUpSession() {
        Task {
            do {
                try await arkitSession.run([worldTrackingProvider])
            } catch {
                fatalError("Faild to start ARKit Session")
            }
        }
    }
    
    public func update(context: SceneUpdateContext) {
        let entities = context.scene.performQuery(Self.query).map { $0 }
        
        guard !entities.isEmpty,
              let pose = worldTrackingProvider.queryDeviceAnchor(atTimestamp: CACurrentMediaTime()) else { return }
        
        let cameraTransform = Transform(matrix: pose.originFromAnchorTransform)
        
        for entity in entities {
            entity.transform = cameraTransform
        }
    }
}
