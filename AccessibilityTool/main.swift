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
    for it in WindowListManager.windowList {
        print(it)
    }

case .a11yScan:
    print("Иерархия для процесса: \(cl.windowPID!)")
    if let pid: pid_t = cl.windowPID {
        if let depth = cl.hierarchyDepth {
            AXController.printHierarchy(forWindowPID: pid, depth: depth)
        } else {
            AXController.printHierarchy(forWindowPID: pid, depth: 0)
        }
    } else {
        print("Не удалось распознать PID процесса")
    }

case .front:
    if let pid: pid_t = cl.windowPID {
        if let str = AXController.getHierarchyForWindowPID(pid, depth: 0) {
            let df = DateFormatter()
            df.dateFormat = "dd.MM.yyyy_HH:mm:ss"
            df.timeZone = TimeZone.current
            let strDate = df.string(from: Date())
            let fileName = "a11y_hierarcghy_" + strDate + ".txt"
            let urlSTR = FileManager.default.homeDirectoryForCurrentUser.relativeString + "Desktop/" + fileName
            guard let url = URL(string: urlSTR) else { fatalError("Не удалось получить URL рабочего стола") }
            do {
                try str.write(to: url, atomically: false, encoding: .utf8)
    } catch {
        fatalError("не удалось записать файл на диск")
    }

        }
    }
}

