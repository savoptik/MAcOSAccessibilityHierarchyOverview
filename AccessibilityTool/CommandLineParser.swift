//
//  CommandLineParser.swift
//  AccessibilityTool
//
//  Created by Артём Семёнов on 22.01.2020.
//  Copyright © 2020 Артём Семёнов. All rights reserved.
//

import Foundation

let helpMessage = "Справка по командам\n" +
"  -h  --help — справка\n" +
"  -g  --getHierarchy — Получить иерархию a11y объектов для окна"

public enum WorkMode: String {
    case a11yScan, help, error
}

public class CommandLineParser {
    private let mode: WorkMode
    private let mEssage: String?
    private let name: String?
    public var workMode: WorkMode {
        get {return mode}
    }
    public var errMessage: String? {
        get {return mEssage}
    }
    public var windowName: String? {
        get {return name}
    }

    public init(cmdLineParametrs: [String]) {
        if cmdLineParametrs.count == 1 {
            mode = .error
            mEssage = "Не введено ни одной команды\n" + helpMessage
            name = nil
            return
        } else if cmdLineParametrs.count > 3 {
            mode = .error
            mEssage = "Слишком много параметров"
            name = nil
            return
        }
        if (cmdLineParametrs[1] == "-h") || (cmdLineParametrs[1] == "--help") {
            if cmdLineParametrs.count == 2 {
                mode = .help
                mEssage = helpMessage
                name = nil
            } else {
                mode = .error
                mEssage = "Слишком много параметров для команды \"help\""
                name = nil
            }
            return
        }
        if (cmdLineParametrs[1] == "-g") || (cmdLineParametrs[1] == "--getHierarchy") {
            if cmdLineParametrs.count == 3 {
                mode = .a11yScan
                mEssage = nil
                name = cmdLineParametrs[2]
            } else {
                mode = .error
                mEssage = "Не указано имя окна"
                name = nil
            }
            return
        }
        mode = .error
        mEssage = "Непонятная ошибка\n" + helpMessage
        name = nil
    }
}
