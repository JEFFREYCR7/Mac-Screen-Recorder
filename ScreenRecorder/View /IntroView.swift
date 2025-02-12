//
//  IntroView.swift
//  ScreenRecorder
//
//  Created by 王杰瑞
//

import SwiftUI

struct IntroView: View {
    @AppStorage("isUserIntroCompleted") private var isUserIntroCompleted: Bool = false
    @Environment(\.dismissWindow) private var dismissWindow
    var body: some View {
        VStack(spacing: 15) {
//            Text("What's New in \n Mac Screen Recorder")
            Text("Mac屏幕录制 \n 新功能")
                .font(.system(size: 35, weight: .bold))
                .multilineTextAlignment(.center)
                .padding(.bottom, 35)
            
            // points
            VStack(alignment: .leading, spacing: 25){
                PointView(title: "录制屏幕", image: "video.fill", description: "以高质量录制捕获您的屏幕。")
                PointView(title: "选择窗口", image: "macwindow", description: "轻松选择任何窗口进行录制")
                PointView(title: "保存录制", image: "folder.fill", description: "轻松点击将您的录制保存到指定位置")
            }
            .padding(.horizontal, 25)
            .padding(.bottom, 60)
            
            // continue/quit bottom
            HStack(spacing: 10){
                Button {
                    NSApplication.shared.terminate(nil)
                } label: {
                    Text("退出")
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(.red.gradient, in: .rect(cornerRadius: 8))
                }
                
                Button {
                    isUserIntroCompleted = true
                    
                    // close current app
                    dismissWindow(id: "IntroView")
                    
                } label: {
                    Text("Mac录屏的状态")
                        .fontWeight(.bold)
                        .foregroundStyle(.background)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.primary.gradient, in: .rect(cornerRadius: 8))
                }
            }
            .buttonStyle(.plain)
        }
        .padding(30)
        .background(.ultraThinMaterial, in: .rect(cornerRadius: 15))
        .gesture(WindowDragGesture()) // 可以拉拽屏幕
    }
    
    // Point View
    @ViewBuilder
    func PointView(title: String, image: String, description: String) -> some View {
        // Basic Point View H&VStack
        HStack(spacing: 15) {
            Image(systemName: image)
                .font(.largeTitle)
                .foregroundStyle(.primary)
                .frame(width: 35)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.callout)
                    .foregroundStyle(.gray)
            }
        }
    }
}

