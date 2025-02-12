//
//  StreamOutput.swift
//  ScreenRecorder
//
//  Created by 王杰瑞
//

import Foundation
import SwiftUI
import ScreenCaptureKit

class StreamOutput: NSObject, SCStreamOutput, SCStreamDelegate, SCRecordingOutputDelegate {
    
    var finishRecording: (() -> Void)?
    
    func stream(_ stream: SCStream, didStopWithError error: any Error) {
        finishRecording?()
    }
    
    func recordingOutput(_ recordingOutput: SCRecordingOutput, didFailWithError error: any Error) {
        finishRecording?()
    }
    
    func recordingOutputDidFinishRecording(_ recordingOutput: SCRecordingOutput) {
        finishRecording?()
    }
}
