//
//  Scale.swift
//  d3s
//
//  Created by ZhangChen on 24/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation

public class Scale<T: Interpolatable> {
//    class func linear() -> Scale<T> {
//        let scale = Continuous(deinterpolate: deinterpolateLinear, reinterpolate: d3s.interpolate)
//        return Linear.linearish(scale: scale)
//    }
}

func deinterpolateLinear<T: FloatingPoint>(a: T, b: T) -> (T) -> T {
    let d = b - a
    return d != 0 ? { x in (x - a) / d } : { _ in b }
}


