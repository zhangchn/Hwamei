//
//  Range.swift
//  d3s
//
//  Created by ZhangChen on 24/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation

//func range<T: Strideable>(start: T, end: T, step: T.Stride) -> StrideThrough<T> {
//    return stride(from: start, through: end, by: step)
//}

func range<T: FloatingPoint & IntConvertible>(start: T = 0, stop: T, step: T = 1) -> [T] {
    return (0..<max(0, ceil((stop - start) / step).asInt())).map {
        start + T($0) * step
    }
}
