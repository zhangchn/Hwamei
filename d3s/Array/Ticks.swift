//
//  Ticks.swift
//  d3s
//
//  Created by ZhangChen on 24/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation

fileprivate let e10 = sqrt(50), e5 = sqrt(10), e2 = M_SQRT2

func ticks(start: Double, stop: Double, count: Int) -> StrideThrough<Double> {
    let step = tickStep(start: start, stop: stop, count: count)
    return range(start: ceil(start / step) * step, end: floor(stop / step) * step + step / 2, step: step)
}

func tickStep(start: Double, stop: Double, count: Int) -> Double {
    let step0 = abs(stop - start) / max(0, Double(count))
    var step1 = pow(10, floor(log(step0) / M_LN10))
    let error = step0 / step1
    
    if error >= e10 {
        step1 *= 10
    } else if error >= e5 {
        step1 *= 5
    } else if error >= e2 {
        step1 *= 2
    }
    
    return stop < start ? -step1 : step1
}
