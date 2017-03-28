//
//  Ticks.swift
//  d3s
//
//  Created by ZhangChen on 24/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation

fileprivate let e10 = 50.squareRoot(), e5 = 10.squareRoot(), e2 = 2.squareRoot()

public func ticks(start: Double, stop: Double, count: Int) -> StrideThrough<Double> {
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

public protocol Tickable: Strideable {
    func asDouble() -> Double
    init(_ doubleValue: Double)
}

extension Double: Tickable {
    public func asDouble() -> Double {
        return self
    }
    
    public init(_ doubleValue: Double) {
        self = doubleValue
    }
}

//func tickStep<S: Tickable>(start: S, stop: S, count: Int) -> S {
//    return S(tickStep(start: start.asDouble(), stop: stop.asDouble(), count: count))
//}

//public func ticks<S: Tickable>(start: S, stop: S, count: Int) -> StrideThrough<Double> {
//    return ticks(start: start.asDouble(), stop: stop.asDouble(), count: count)
//}
