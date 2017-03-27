//
//  Format.swift
//  d3s
//
//  Created by ZhangChen on 27/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation


/// Poor man's shim for d3-formats

public typealias FormatFunc = (Double) -> String
public func format(_ f: String = "") -> FormatFunc {
    let format = Format(format: f)
    return { t in
        format.data = t
        return format.description
    }
}

public class Format {
    var _format: String
    internal var data: Double = 0
    init(format: String) {
        _format = format
    }
    var description: String {
        return String.init(format: "%" + _format + "f", data)
    }
}
