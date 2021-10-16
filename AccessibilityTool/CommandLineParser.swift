//
//  CommandLineParser.swift
//  AccessibilityTool
//
//  Created by Артём Семёнов on 22.01.2020.
//  Copyright © 2020 Артём Семёнов. All rights reserved.
//

import Foundation

let helpMessage = "Command Reference\n" +
"  -l --list - List windows\n" +
"  -g --getHierarchy - Get a11y object hierarchy for the window PID\n" +
    "  -f --front - Get the hierarchy for the currently active window\n" +
"  -h --help - help\n"

public enum WorkMode: String {
    case a11yScan, help, error, list, front
}

public class CommandLineParser {
    private var mode: WorkMode
    private var mEssage: String? = nil
    private var pid: Int32? = nil
    private var depth: Int32? = nil
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
        let count = cmdLineParametrs.count
        if count <= 1 {
            mEssage = Errors.parametersNotSpecified.rawValue + "\n\(helpMessage)"
            mode = .error
            return
        }
        if count > 4 {
            mode = .error
            mEssage = Errors.TooManyParameters.rawValue + "\n\(helpMessage)"
        }
        if let countVar = CLIParms.countValuesForParm[cmdLineParametrs[1]] {
            if count <= countVar {
                let cmdPrm = cmdLineParametrs[1]
                switch CLIParms.getParmType(cmdPrm) {
                case CLIParmType.help:
                    mode = .help
                case CLIParmType.list:
                    mode = .list
                case CLIParmType.front:
                    pid = WindowListManager.activePID
                    mode = .front
                case CLIParmType.hierarchy:
                    mode = .a11yScan
                    if count == 2 {
                        if let strSTDIn = readLine(),
                           let strPID = strSTDIn.split(separator: " ").first,
                           let tmppid = Int32(strPID),
                        tmppid >= 0 {
                            pid = tmppid
                        } else {
                            mode = .error
                            mEssage = Errors.failedToGetSTDIn.rawValue
                        }
                    }
                    if count > 2 {
                        if let tmppid = Int32(cmdLineParametrs[2]), tmppid >= 0 {
                            pid = tmppid
                        } else {
                            mode = .error
                            mEssage = Errors.incorrectlySetPID.rawValue
                            return
                        }
                        if count == 4 {
                            if let tmpD = Int32(cmdLineParametrs[3]), tmpD >= 0 {
                                depth = tmpD
                            } else {
                                mode = .error
                                mEssage = Errors.theDepthOfTheWalkIsIncorrect.rawValue
                            }
                        }
                    }
                default:
                    mode = .error
                    mEssage = Errors.UnknownError.rawValue + "\n\(helpMessage)"
                }
            } else {
                mode = .error
                mEssage = Errors.tooManyValuesForParameter.rawValue
            }
        } else {
            mode = .error
            mEssage = cmdLineParametrs[1] + " \(Errors.parmNotFound.rawValue)\n\(helpMessage)"
        }
    }

    private enum Errors: String, Error  {
        case parametersNotSpecified = "Parameters not set"
        case TooManyParameters = "Too many parameters"
        case tooManyValuesForParameter = "Too many values for a parameter"
        case thisParameterCanHaveOnlyOneValue = "This parameter can only have one value"
        case theDepthOfTheWalkIsIncorrect = "The depth of the traversal is not set correctly"
        case incorrectlySetPID = "PID set incorrectly"
        case UnknownError = "Unknown error"
        case parmNotFound = "Parameter not found"
        case failedToGetSTDIn = "failed to get STDIn"
    }

    private enum CLIParmType {
    case help, list, front, hierarchy, fale
    }

    private struct CLIParms {
        static let help: (short: String, long: String) = ("-h", "--help")
        static let list: (short: String, long: String) = ("-l", "--list")
        static let getHierarchy: (short: String, long: String) = ("-g", "--getHierarchy")
        static let front: (short: String, long: String) = ("-f", "--front")
        
        public static var countValuesForParm: [String: UInt8] {
            get {
                return [
                    help.short : 2, help.long : 2,
                    list.short : 2, list.long : 2,
                    getHierarchy.short : 4, getHierarchy.long : 4,
                    front.short : 2, front.long : 2
                ]
            }
        }

        private static func isHelp(_ parm: String) -> Bool {
            return parm.lowercased() == help.short.lowercased() || parm.lowercased() == help.long.lowercased()
        }

        private static func isList(_ parm: String) -> Bool {
            return parm.lowercased() == list.short.lowercased() || parm.lowercased() == list.long.lowercased()
        }

        private static func isGetHierarchy(_ parm: String) -> Bool {
            return parm.lowercased() == getHierarchy.short.lowercased() || parm.lowercased() == getHierarchy.long.lowercased()
        }

        private static func isFront(_ parm: String) -> Bool {
            return parm.lowercased() == front.short.lowercased() || parm.lowercased() == front.long.lowercased()
        }

        public static func getParmType(_ parm: String) -> CLIParmType {
            if isHelp(parm) {
                return .help
            }
            if isList(parm) {
                return .list
            }
            if isGetHierarchy(parm) {
                return .hierarchy
            }
            if isFront(parm) {
                return .front
            }
            return .fale
        }
    }
}
