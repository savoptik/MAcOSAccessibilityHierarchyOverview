//
//  WindowListManager.swift
//  AccessibilityTool
//
//  Created by Артём Семёнов on 22.01.2020.
//  Copyright © 2020 Артём Семёнов. All rights reserved.
//

import Foundation
import CoreGraphics
import AppKit

class WindowListManager {
    private let list: [String]
    public var windowList: [String] {
        get {return list}
    }

    public init() {
        var winList: [String] = []
        if let info = CGWindowListCopyWindowInfo(.optionOnScreenOnly, kCGNullWindowID) as? [[String: Any]] {
            for dic in info {
                winList.append("\(dic["kCGWindowOwnerPID"]!) " + "\(dic["kCGWindowOwnerName"]!)")
            }
        }
        list = Set(winList).sorted(by: {
            let first = $0[$0.firstIndex(of: " ")!...]
            let second = $1[$1.firstIndex(of: " ")!...]
            return first < second
        })
    }

}
