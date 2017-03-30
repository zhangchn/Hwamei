//
//  Format.swift
//  d3s
//
//  Created by ZhangChen on 27/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation


/// Poor man's shim for d3-formats

public typealias FormatFunc = (CustomStringConvertible) -> String
public func format(_ f: String = "") -> FormatFunc {
    return { t in
        if let t = t as? Double {
            return String(format: "%" + f + "f", t)
        } else if let t = t as? String {
            return String(format: "%" + f + "s", t)
        }
        return t.description
    }
}

public class Format {
    var _format: String
//    internal var data: Any!
//    internal var conversion: String!
    init(format: String) {
        _format = format
    }
//    var description: String {
//        return String.init(format: "%" + _format + conversion, data as! CVarArg)
//    }
}
