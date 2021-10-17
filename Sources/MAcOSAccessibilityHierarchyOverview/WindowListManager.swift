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

    public static var windowList: [String] {
        get {
            var winList: [String] = []
            if let info = CGWindowListCopyWindowInfo(.optionOnScreenOnly, kCGNullWindowID) as? [[String: Any]] {
                for dic in info {
                    winList.append("\(dic["kCGWindowOwnerPID"]!) " + "\(dic["kCGWindowOwnerName"]!)")
                }
            }
            return             Set(winList).sorted(by: {
                let first = $0[$0.firstIndex(of: " ")!...]
                let second = $1[$1.firstIndex(of: " ")!...]
                return first < second
            })
        }
    }

    public static var activePID: pid_t {
        get {
            if let frontmostApplication = NSWorkspace.shared.frontmostApplication {
                return frontmostApplication.processIdentifier
            } else {
                return -1;
            }
        }
    }
}
