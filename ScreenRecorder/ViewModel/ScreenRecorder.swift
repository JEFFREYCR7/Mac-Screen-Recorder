//
//  ScreenRecorder.swift
//  ScreenRecorder
//
//  Created by 王杰瑞
//

import SwiftUI
import ScreenCaptureKit

@MainActor
class ScreenRecorder: NSObject, ObservableObject, @preconcurrency SCContentSharingPickerObserver {
    override init() {
        super.init()
        setupWindowPicker()
    }
    
    @Published var showCursor: Bool = true
    @Published var capturesAudio: Bool = true
    @Published var backgroundColor: Color = .white
    @Published var videoScale: VideoScale = .normal
    @Published var isRecording: Bool = false
    
    // private properties
    private var contentFilter: SCContentFilter?
    private var stream: SCStream?
    private var streamOutput = StreamOutput()
    
    // 设置stream并录制所选窗口
    private func setupAndRecordWindow(_ url: URL) async throws {
        guard let contentFilter else { return }
        
        let configuration = SCStreamConfiguration()
        configuration.showsCursor = showCursor
        configuration.capturesAudio = capturesAudio
        
        // 一些 SwiftUI 颜色不能被 Screen-Capture-Kit 捕捉，"白色" 也包含在这个列表中。
        configuration.backgroundColor = backgroundColor == .white ? .white : NSColor(backgroundColor).cgColor
        
        let scale = CGFloat(videoScale.rawValue)
        let scaledVideoSize = contentFilter.contentRect.size.applying(.init(scaleX: scale, y: scale))
        configuration.width = Int(scaledVideoSize.width)
        configuration.height = Int(scaledVideoSize.height)
        configuration.scalesToFit = true
         
        let stream = SCStream(filter: contentFilter, configuration: configuration, delegate: streamOutput)
        
        // 添加单独的队列
        try stream.addStreamOutput(streamOutput, type: .audio, sampleHandlerQueue: nil)
        try stream.addStreamOutput(streamOutput, type: .screen, sampleHandlerQueue: nil)
        
        // 文件保存配置
        let outputConfiguration = SCRecordingOutputConfiguration()
        outputConfiguration.outputURL = url
        outputConfiguration.outputFileType = .mov
        
        let output = SCRecordingOutput(configuration: outputConfiguration, delegate: streamOutput)
        try stream.addRecordingOutput(output)
        
        // 开始捕获
        try await stream.startCapture()
        
        self.isRecording = true
        self.stream = stream
        
        streamOutput.finishRecording = {
            // UI 更新必须在主线程上执行
            Task { @MainActor in
                self.stream = nil
                self.contentFilter = nil
                self.isRecording = false
            }
        }
    }
    
    func stopWindowRecording() {
        Task {
            do {
                try await stream?.stopCapture()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    // 请求保存录制文件的位置
    private func askFileLocation() {
        Task {
            do {
                let panel = NSOpenPanel()
                panel.canChooseFiles = false
                panel.canChooseDirectories = true
                panel.allowsMultipleSelection = false
                panel.showsHiddenFiles = false
                
                let response = panel.runModal()
                if response == .OK {
                    if let fileURL = panel.url?.appending(path: "Recording \(Date()).mov") {
                        try await setupAndRecordWindow(fileURL)
                        print(fileURL)
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

// 使用 Screen-Capture-Kit 设置新的窗口选择器
extension ScreenRecorder {
    func setupWindowPicker() {
        var pickerConfiguration = SCContentSharingPickerConfiguration()
        pickerConfiguration.allowedPickerModes = .singleWindow
        pickerConfiguration.allowsChangingSelectedContent = false
        SCContentSharingPicker.shared.configuration = pickerConfiguration
        SCContentSharingPicker.shared.add(self)
        
    }
    
    func contentSharingPicker(_ picker: SCContentSharingPicker, didCancelFor stream: SCStream?) {
        SCContentSharingPicker.shared.isActive = false
    }
    
    func contentSharingPicker(_ picker: SCContentSharingPicker, didUpdateWith filter: SCContentFilter, for stream: SCStream?) {
        // 这意味着窗口已经被选择，现在我们关闭选择器视图，并请求保存录制文件的位置
        SCContentSharingPicker.shared.isActive = false
        contentFilter = filter
        askFileLocation()
        
    }
    
    func contentSharingPickerStartDidFailWithError(_ error: any Error) {
        // handle errors
        
    }
}
    
