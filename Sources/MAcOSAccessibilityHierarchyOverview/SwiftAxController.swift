//
// Created by Артём Семёнов on 17.10.2021.
// Copyright (c) 2021 Артём Семёнов. All rights reserved.
//

import Foundation
import AppKit

public class SwiftAxController {
 private let depth: Int

 public init(WithDepth d: Int) {
  depth = d
 }

 private static func getWindow(FoPID pid: Int32) -> NSRunningApplication? {
  let apps = NSWorkspace.shared.runningApplications
  let app: [NSRunningApplication] = apps.filter({ $0.processIdentifier == pid })
  if app.count == 1 {
   return app[0]
  }

  return nil
}

 public func getHierarchy(ForWindowPID pid: Int32) -> String{
     guard let app = SwiftAxController.getWindow(FoPID: pid) else {
   fatalError("Failed to get application by this ID")
  }

     guard let axFocused = app.accessibilityFocusedUIElement as? NSAccessibilityElement else {
   fatalError("Failed to get accessibility item")
  }

  return getHierarchy(ForAccessibilityElement: axFocused, 0)
 }

 private func getHierarchy(ForAccessibilityElement ax: NSAccessibilityElement, _ level: Int) -> String {
  return getHierarchy(ForAccessibilityElement: ax, level, "")
 }

 private func getHierarchy(ForAccessibilityElement ax: NSAccessibilityElement, _ level: Int, _ s: String) -> String {
  var role = "none"
  if let r = ax.accessibilityRole() {
      role = r.rawValue
  }

  var name = "none"
  if let n = ax.accessibilityLabel() {
   name = n
  }

  var returnSTR = s + String(repeating: " ", count: level) + "\(level). Role: \(role), name: \(name)\n"

  if level == depth {
   return returnSTR
  }

  guard let children = ax.accessibilityChildren() as? [NSAccessibilityElement] else {
   fatalError("Failed to get accessible children")
  }

  for child in children {
   returnSTR = getHierarchy(ForAccessibilityElement: child, level + 1, returnSTR)
  }

  return returnSTR
 }

 public func printHierarchy(ForWindowPID pid: Int32) {
 print(self.getHierarchy(ForWindowPID: pid))
}
}
