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
    print("Hierarchy for a process: \(cl.windowPID!)")
    if let pid: pid_t = cl.windowPID {
        if let depth = cl.hierarchyDepth {
            AxController(WithDepth: Int(depth)).printHierarchy(ForWindowPID: pid)
        } else {
            AxController(WithDepth: 0).printHierarchy(ForWindowPID: pid)
        }
    } else {
        print("The process PID could not be recognized")
    }

case .front:
    if let pid: pid_t = cl.windowPID {
        let str = AxController(WithDepth: 0).getHierarchy(ForWindowPID: pid)
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yyyy_HH:mm:ss"
        df.timeZone = TimeZone.current
        let strDate = df.string(from: Date())
        let fileName = "a11y_hierarchy_" + strDate + ".txt"
        let urlSTR = FileManager.default.homeDirectoryForCurrentUser.relativeString + "Desktop/" + fileName
        guard let url = URL(string: urlSTR) else {
            fatalError("Не удалось получить URL рабочего стола")
        }
        do {
            try str.write(to: url, atomically: false, encoding: .utf8)
        } catch {
            fatalError("не удалось записать файл на диск")
        }
    }
}

