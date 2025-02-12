//
//  ScreenRecorderApp.swift
//  ScreenRecorder
//
//  Created by 王杰瑞
//

import SwiftUI

@main
struct ScreenRecorderApp: App {
    
    @AppStorage("isUserIntroCompleted") private var isUserIntroCompletetd: Bool = false
    @State private var introScreenShowed: Bool = false
    // Environment Values
    @Environment(\.openWindow) private var openWindow
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        // 屏幕录制完成后才添加菜单栏
        MenuBarExtra("Mac Screen Recorder", systemImage: "inset.filled.rectangle.badge.record", isInserted:
                .constant(isUserIntroCompletetd)) {
                    MenuView() 
        }
        .menuBarExtraStyle(.window)
        .onChange(of: scenePhase, initial: true) {
            oldValue, newValue in
            if !isUserIntroCompletetd && !introScreenShowed {
                openWindow(id: "IntroView")
                introScreenShowed = true
            }
        }
            
        WindowGroup(id: "IntroView") {
            IntroView()
        }
        .windowLevel(.floating)
        .windowStyle(.plain)
        .restorationBehavior(.disabled)
        // 将其放置在屏幕中心
        .defaultWindowPlacement { content, context in
            let displaySize = context.defaultDisplay.visibleRect.size
            let size = content.sizeThatFits(.init(displaySize))
            
            return .init(.center, size: size)
        }
    }
}
