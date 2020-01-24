//
//  main.swift
//  AccessibilityTool
//
//  Created by Артём Семёнов on 22.01.2020.
//  Copyright © 2020 Артём Семёнов. All rights reserved.
//

import Foundation

let cl = CommandLineParser(cmdLineParametrs: CommandLine.arguments)
switch cl.workMode {
case .error:
    print(cl.errMessage!)

case .help:
    print(cl.errMessage!)

case .list:
    for it in WindowListManager().windowList {
        print(it)
    }

case .a11yScan:
    print("Иерархия для процесса: \(cl.windowPID!)")
    if let pid: pid_t = cl.windowPID {
        if let depth = cl.hierarchyDepth {
            AXController.printHierarchy(forWindowPID: pid, depth: depth)
        }
    } else {
        print("Не удалось распознать PID процесса")
    }
}

