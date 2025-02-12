//
//  MenuView.swift
//  ScreenRecorder
//
//  Created by 王杰瑞
//

import Foundation
import SwiftUI
import ScreenCaptureKit

let colors: [Color] = [.white, .red, .blue, .green, .yellow, .orange, .purple]

struct MenuView: View {
    @StateObject private var screenRecorder: ScreenRecorder = .init()
    @State private var isPermissionGranted: Bool = false
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // recorder properties
            VStack(alignment: .leading, spacing: 12) {
                Text("属性")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .padding(.bottom, -6)
                
                Toggle(isOn: $screenRecorder.showCursor) {
                    Text("显示光标")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Toggle(isOn: $screenRecorder.capturesAudio) {
                    Text("捕获音频")
                        .frame(maxWidth:.infinity, alignment: .leading)
                }
                
                Picker("背景颜色", selection: $screenRecorder.backgroundColor) {
                    ForEach(colors, id: \.self) {
                        color in
                        Text(String(describing: color).capitalized)
                            .tag(color)
                        
                    }
                }
                Picker("视频倍速", selection: $screenRecorder.videoScale) {
                    ForEach(VideoScale.allCases, id: \.rawValue) { scale in
                        Text(scale.stringValue)
                            .tag(scale)
                    }
                }
                .pickerStyle(.segmented)
                .disabled(screenRecorder.isRecording)
                .opacity(screenRecorder.isRecording ? 0.5 : 1)
                
            }
            .toggleStyle(.switch)
            
            // window Picker Button
            Button {
                if screenRecorder.isRecording {
                    screenRecorder.stopWindowRecording()
                } else {
                    // showing window picker
                    SCContentSharingPicker.shared.isActive = true
                    SCContentSharingPicker.shared.present()
                }
            } label: {
                Text(screenRecorder.isRecording ? "停止录制" : "选择窗口")
                    .fontWeight(.semibold)
                    .foregroundStyle(.background)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 20)
                    .background(Color.primary.gradient, in: .rect(cornerRadius: 8))
            }
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity)
            .padding(.top, 5)
            
            // Quit Button
            Button("Quit") {
                // Quit APP
                NSApplication.shared.terminate(nil)
            }
            .buttonStyle(.plain)
            .pointerStyle(.link)
            .foregroundStyle(.red)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.top, 5)
            .disabled(screenRecorder.isRecording )
        }
        .padding(15)
        .frame(width: 240)
        // 隐私与安全性的设置：录屏与系统声音
        .overlay {
            if !isPermissionGranted {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .overlay {
                        Text("没有屏幕录制权限\n\n请在系统设置中授予权限")
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color.primary)
                    }
            }
        }
 
        .onAppear {
            isPermissionGranted = CGRequestScreenCaptureAccess()
        }
    }
}

#Preview {
    MenuView()
}
