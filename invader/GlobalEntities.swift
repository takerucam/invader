//
//  GlobalEntities.swift
//  invader
//
//  Created by 三宅武将 on 2023/12/16.
//

import RealityKit

// ルートEntity
let spaceOrigin = Entity()

// ユーザーの頭部のAnchorEntity
// ユーザーの頭部をカメラの位置とする
let cameraAnchor = AnchorEntity(.head)

var enemyEntities: [Entity] = []
