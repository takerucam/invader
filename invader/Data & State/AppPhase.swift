//
//  AppPhase.swift
//  invader
//
//  Created by 三宅武将 on 2024/04/28.
//

import Foundation

public enum AppPhase {
    case startingUp         // アプリ起動中
    case loadingAssets      // アセットローディング中
    case watingToStart      // ホーム画面
    case playing            // ゲームプレイ中
    case result             // プレイ結果画面
    
    var isImmersed: Bool {
        switch self {
        case .startingUp, .loadingAssets, .watingToStart, .result:
            return false
        case .playing:
            return true
        }
    }
    
    mutating public func transition(to newPhase: AppPhase) {
        guard self != newPhase else { return }
        self = newPhase
    }
}
