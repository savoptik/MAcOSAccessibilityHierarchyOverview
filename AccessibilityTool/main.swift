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
    print("Построение иерархии для окна \(cl.windowName!)")
}

