//
// Created by Артём Семёнов on 17.10.2021.
// Copyright (c) 2021 Артём Семёнов. All rights reserved.
//

import Foundation
import AppKit
import MacOSAccessibilityApplicationWrapper

public class AxController {
 private let depth: Int

 public init(WithDepth d: Int) {
  depth = d
 }

 public func getHierarchy(ForWindowPID pid: Int32) -> String{
  do {
   let app = try MacOSAccessibilityElementWrapper(WithPID: pid)
   return getHierarchy(ForAccessibilityElement: app, 0)
  } catch {
   fatalError(error.localizedDescription)
  }
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

  var returnSTR = s + String(repeating: " ", count: level * 2) + "\(level). Role: \(role), name: \(name)\n"

  if (depth != 0) &&
             (level == depth) {
   return returnSTR
  }

  guard let children = ax.accessibilityChildren() as? [MacOSAccessibilityElementWrapper] else {
   return returnSTR
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
