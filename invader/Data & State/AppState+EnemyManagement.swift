//
//  AppState+EnemyManagement.swift
//  invader
//
//  Created by 三宅武将 on 2024/04/30.
//

import Foundation

extension AppState {
    
    /// 敵のentityをRealityViewに追加
    public func addEnemiesToScene() {
        for entity in self.enemies {
            self.root.addChild(entity)
        }
    }
}
