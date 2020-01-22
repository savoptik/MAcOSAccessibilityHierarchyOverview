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
case .a11yScan:
    print("Будем распознавать окно \(cl.windowName!)")
}

