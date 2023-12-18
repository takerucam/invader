//
//  Enemy.swift
//  invader
//
//  Created by 三宅武将 on 2023/12/16.
//

import Accessibility
import RealityKit
import Spatial
import SwiftUI

class Enemy: Identifiable {
    var id: Int
    var isEnemyDefeated: Bool
    
    init(id: Int, isEnemyDefeated: Bool) {
        self.id = id
        self.isEnemyDefeated = isEnemyDefeated
    }
}

var enemyTemplate: Entity?
var enemyCount = 0
var enemyMovementAnimations: [AnimationResource] = []
var enemyAnimation: AnimationResource?

var enemyPathsIndex = 0
let enemyPaths: [(Double, Double, Double)] = [
    (x: 1.757_231_498_429_01, y: 1.911_673_694_896_59, z: -8.094_368_331_589_704),
    (x: -0.179_269_237_592_594_17, y: 1.549_268_306_906_908_4, z: -7.254_713_426_424_875),
    (x: -0.013_296_800_013_828_491, y: 2.147_766_026_068_617_8, z: -8.601_541_438_900_849),
    (x: 2.228_704_746_539_703, y: 0.963_797_733_336_365_2, z: -7.183_621_312_117_454),
    (x: -0.163_925_123_812_864_4, y: 1.821_619_897_406_197, z: -8.010_893_563_433_282),
    (x: 0.261_716_575_589_896_03, y: 1.371_932_443_334_715, z: -7.680_206_361_333_17),
    (x: 1.385_410_631_256_254_6, y: 1.797_698_998_556_775_5, z: -7.383_548_882_448_866),
    (x: -0.462_798_470_454_367_4, y: 1.431_650_092_907_264_4, z: -7.169_154_476_151_876),
    (x: 1.112_766_805_791_563, y: 0.859_548_406_627_492_2, z: -7.147_229_496_720_969),
    (x: 1.210_194_536_657_374, y: 0.880_254_638_358_228_8, z: -8.051_132_737_691_349),
    (x: 0.063_637_772_899_141_52, y: 1.973_172_635_040_014_7, z: -8.503_837_407_474_947),
    (x: 0.883_082_630_134_997_2, y: 1.255_268_496_843_653_4, z: -7.760_994_300_660_705),
    (x: 0.891_719_821_716_725_7, y: 2.085_000_111_104_786_7, z: -8.908_048_018_555_112),
    (x: 0.422_260_067_132_894_2, y: 1.370_335_319_771_187, z: -7.525_853_388_894_509),
    (x: 0.473_470_811_107_753_46, y: 1.864_930_149_962_240_6, z: -8.164_641_191_459_626)
]

// インベーダーを生成
@MainActor
func spawnEnemy() async throws -> Entity {
    let start = Point3D(
        x: enemyPaths[enemyPathsIndex].0,
        y: enemyPaths[enemyPathsIndex].1,
        z: enemyPaths[enemyPathsIndex].2
    )
    
    let enemy = try await spawnEnemyExact(start: start, end: .init(
        x: start.x + 0.02,
        y: start.y - 0.12,
        z: start.z + 12.0
    )
    )
    
    enemyPathsIndex += 1
    enemyPathsIndex %= enemyPaths.count
    
    enemyEntities.append(enemy)
    return enemy
}

@MainActor
private func spawnEnemyExact(start: Point3D, end: Point3D) async throws -> Entity {
    if enemyTemplate == nil {
        guard let enemy = await loadFromRealityComposerPro(named: "Invader.usda") else {
            fatalError("ERROR")
        }
        enemyTemplate = enemy
    }
    guard let enemyTemplate = enemyTemplate else {
        fatalError("Template nil")
    }
    
    let enemy = enemyTemplate.clone(recursive: true)
    enemy.generateCollisionShapes(recursive: true)
    enemy.name = "Enemy-\(enemyCount)"
    enemyCount += 1
    
    enemy.components[PhysicsBodyComponent.self] = PhysicsBodyComponent()
    
    enemy.position = simd_float(start.vector + .init(x: 0, y: 0, z: -0.7))
    
    var accessibilityComponent = AccessibilityComponent()
    accessibilityComponent.label = "Enemy"
    accessibilityComponent.value = "Grumpy"
    accessibilityComponent.isAccessibilityElement = true
    accessibilityComponent.traits = [.button, .playsSound]
    accessibilityComponent.systemActions = [.activate]
    enemy.components[AccessibilityComponent.self] = accessibilityComponent
    
    let animation = enemyMovementAnimations[enemyPathsIndex]
    
    enemy.playAnimation(animation, transitionDuration: 1.0, startsPaused: false)
    enemy.setMaterialParameterValues(parameter: "saturation", value: .float(0.0))
    enemy.setMaterialParameterValues(parameter: "animate_texture", value: .bool(false))
    
    guard let resource = try? await EnvironmentResource(named: "whiteLighting") else {
        spaceOrigin.addChild(enemy)
        return enemy
    }
    
    let imageLight = ImageBasedLightComponent(source: .single(resource), intensityExponent: 2.0)
    enemy.components.set(imageLight)
    enemy.components.set(ImageBasedLightReceiverComponent(imageBasedLight: enemy))
    
    spaceOrigin.addChild(enemy)
    
    return enemy
}

func generateEnemyAnimation() {
    for index in 0..<enemyPaths.count {
        let start = Point3D(
            x: enemyPaths[index].0,
            y: enemyPaths[index].1,
            z: enemyPaths[index].2
        )
        let end = Point3D(
            x: start.x + 0.02,
            y: start.y - 0.12,
            z: start.z + 12.0
        )
        let line = FromToByAnimation<Transform>(
            name: "line",
            from: .init(scale: .init(repeating: 1), translation: simd_float(start.vector)),
            to: .init(scale: .init(repeating: 1), translation: simd_float(end.vector)),
            duration: 12,
            bindTarget: .transform
        )
        
        let animation = try! AnimationResource
            .generate(with: line)
        
        enemyMovementAnimations.append(animation)
    }
}

func postEnemyOverviewAnnouncement(gameModel: GameModel) {
//    guard !enemyEntities.isEmpty else {
//        return
//    }
//    var averageCameraPositionFront: SIMD3<Float> = [0, 0, 0]
//    var averageCameraPositionBehind: SIMD3<Float> = [0, 0, 0]
//    var enemiesFront = 0
//    var enemiesBehind = 0
//    for enemy in enemyEntities {
//        let enemyInstance = gameModel.enemies.first(where: { enemryInstance in
//            if ("Enemy" + String(enemryInstance.id)) == enemy.name {
//                return true
//            }
//            return false
//        })
//        if enemyInstance?.isEnemyDefeated ?? false {
//            continue
//        }
//        let enemyPosition = enemy.position(relativeTo: cameraAnchor)
//        if enemyPosition.z > 0 {
//            averageCameraPositionBehind += enemyPosition
//            enemiesBehind += 1
//        } else {
//            averageCameraPositionFront += enemyPosition
//            enemiesFront += 1
//        }
//    }
//    averageCameraPositionFront /= [Float(enemiesFront), Float(enemiesFront), Float(enemiesFront)]
//    var enemyPositioningAnnouncementFront = String(format: "%d \(enemiesFront > 1 ? "enemies" : "enemy")", enemiesFront)
//    if averageCameraPositionFront.y > 0.5 {
//        enemyPositioningAnnouncementFront += " above and in front of you "
//    } else if averageCameraPositionFront.y < -0.5 {
//        enemyPositioningAnnouncementFront += " below and in front of you "
//    } else {
//        enemyPositioningAnnouncementFront += " in front of you "
//    }
//    
//    if averageCameraPositionFront.x > 0.5 {
//        enemyPositioningAnnouncementFront += "to the right"
//    } else if averageCameraPositionFront.x < -0.5 {
//        enemyPositioningAnnouncementFront += "to the left"
//    }
//    
//    averageCameraPositionBehind /= [Float(enemiesBehind), Float(enemiesBehind), Float(enemiesBehind)]
//    var enemyPositioningAnnouncementBehind = String(format: "%d \(enemiesBehind > 1 ? "enemies" : "enemy")", enemiesBehind)
//    if averageCameraPositionBehind.y > 0.5 {
//        enemyPositioningAnnouncementBehind += " above and behind you "
//    } else if averageCameraPositionBehind.y < -0.5 {
//        enemyPositioningAnnouncementBehind += " below and behind you "
//    } else {
//        enemyPositioningAnnouncementBehind += " behind you "
//    }
//    
//    if averageCameraPositionBehind.x > 0.5 {
//        enemyPositioningAnnouncementBehind += "to the right"
//    } else if averageCameraPositionBehind.x < -0.5 {
//        enemyPositioningAnnouncementBehind += "to the left"
//    }
//    
//    var enemyPositioningAnnouncement = ""
//    if enemiesFront > 0 && enemiesBehind == 0 {
//        enemyPositioningAnnouncement = enemyPositioningAnnouncementFront
//    } else if enemiesBehind > 0 && enemiesFront == 0 {
//        enemyPositioningAnnouncement = enemyPositioningAnnouncementBehind
//    } else {
//        enemyPositioningAnnouncement = enemyPositioningAnnouncementFront + " " + enemyPositioningAnnouncementBehind
//    }
//    
//    AccessibilityNotification.Announcement(enemyPositioningAnnouncement).post()
}
