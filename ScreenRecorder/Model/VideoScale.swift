//
//  VideoScale.swift
//  ScreenRecorder
//
//  Created by 王杰瑞
//

import Foundation
import SwiftUI

enum VideoScale: Int, CaseIterable {
    case normal = 1
    case twoTines = 2
    
    var stringValue: String {
        switch self {
        case .normal:
            return "1x"
        case .twoTines:
            return "2x"
        }
    }
}
