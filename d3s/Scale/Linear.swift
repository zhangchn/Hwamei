//
//  Linear.swift
//  d3s
//
//  Created by ZhangChen on 24/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation


func deinterpolateLinear<T: FloatingPoint>(a: T, b: T) -> (T) -> T {
    let d = b - a
    return d != 0 ? { x in (x - a) / d } : { _ in b }
}

public class Linear<S: ReversibleInterpolatable, T: ReversibleInterpolatable>: Continuous<S,T> {
// TODO:
}
