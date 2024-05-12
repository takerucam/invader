//
//  AppState+Phase.swift
//  invader
//
//  Created by 三宅武将 on 2024/04/28.
//

import Foundation

extension AppState {
    
    public func finishedStartingUp() {
        phase.transition(to: .loadingAssets)
    }
    
    public func finishedLoadingAssets() {
        phase.transition(to: .watingToStart)
    }
    
    public func startPlaying() {
        phase.transition(to: .playing)
    }
    
    public func finishedPlaying() {
        phase.transition(to: .result)
    }
    
    public func retryPlaying() {
        phase.transition(to: .playing)
    }
    
    public func goBackToHome() {
        phase.transition(to: .watingToStart)
    }
}
