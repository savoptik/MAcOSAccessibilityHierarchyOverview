//
//  CommandLineParser.swift
//  AccessibilityTool
//
//  Created by Артём Семёнов on 22.01.2020.
//  Copyright © 2020 Артём Семёнов. All rights reserved.
//

import Foundation

let helpMessage = "Справка по командам\n" +
"  -l --list — Список окон\n" +
"  -g  --getHierarchy — Получить иерархию a11y объектов для PID окна\n" +
"  -h  --help — справка"

public enum WorkMode: String {
    case a11yScan, help, error, list
}

public class CommandLineParser {
    private let mode: WorkMode
    private let mEssage: String?
    private let pid: Int32?
    private let depth: Int32?
    public var workMode: WorkMode {
        get {return mode}
    }
    public var errMessage: String? {
        get {return mEssage}
    }
    public var windowPID: Int32? {
        get {return pid}
    }
    public var hierarchyDepth: Int32? {
        get {return depth}
    }

    public init(cmdLineParametrs: [String]) {
        if cmdLineParametrs.count == 1 {
            mode = .error
            mEssage = "Не введено ни одной команды\n" + helpMessage
            pid = nil
            depth = nil
            return
        } else if cmdLineParametrs.count > 4 {
            mode = .error
            mEssage = "Слишком много параметров"
            pid = nil
            depth = nil
            return
        }
        if (cmdLineParametrs[1] == "-h") || (cmdLineParametrs[1] == "--help") {
            if cmdLineParametrs.count == 2 {
                mode = .help
                mEssage = helpMessage
                pid = nil
                depth = nil
            } else {
                mode = .error
                mEssage = "Слишком много параметров для команды \"help\""
                pid = nil
                depth = nil
            }
            return
        }
        if (cmdLineParametrs[1] == "-l") || (cmdLineParametrs[1] == "--list") {
            if cmdLineParametrs.count == 2 {
                mode = .list
                mEssage = nil
                pid = nil
                depth = nil
            } else {
                mode = .error
                mEssage = "Слишком много параметров для команды \"list\""
                pid = nil
                depth = nil
            }
            return
        }
        if (cmdLineParametrs[1] == "-g") || (cmdLineParametrs[1] == "--getHierarchy") {
            if cmdLineParametrs.count == 4 {
                if let d = Int32(cmdLineParametrs[3]) {
                    depth = d
                } else {
depth = nil
                }
                if let p = Int32(cmdLineParametrs[2]) {
                    pid = p
                } else {
                    pid = nil
                }
                if pid != nil {
                    if depth != nil {
                        mEssage = nil
                        mode = .a11yScan
                    } else {
                        mEssage = "Не удалось получить глубину обхода"
                        mode = .error
                    }
                } else {
                    mEssage = "не удалось получить PID процесса"
                    mode = .error
                }
            } else if cmdLineParametrs.count == 3  {
                if let p = Int32(cmdLineParametrs[2]) {
                    mode = .a11yScan
                    mEssage = nil
                    pid = p
                    depth = 0
                } else {
                    mode = .error
                    mEssage = "Не удалось получить PID процесса"
                    pid = nil
                    depth = nil
                }
            } else {
                mode = .error
                mEssage = "Не указано имя окна"
                pid = nil
                depth = nil
            }
            return
        }
        mode = .error
        mEssage = "Непонятная ошибка\n" + helpMessage
        pid = nil
        depth = nil
    }
}
