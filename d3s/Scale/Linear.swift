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


public class Linear<S: ReversibleInterpolatable & Tickable, T: ReversibleInterpolatable>: Continuous<S,T> {
    public func ticks(count: Int = 10) -> StrideThrough<Double> {
        let first = _domain.first!
        let last = _domain.last!
        return d3s.ticks(start: first.asDouble(), stop: last.asDouble(), count: count)
    }
    
    public func tickFormat(count: Int, specifier: String = "") -> FormatFunc {
        return d3s.tickFormat(domain: _domain.map { $0.asDouble() },
                              count: count,
                              specifier: specifier)
    }
    
    public func nice(count: Int = 10) -> Self {
        var d = domain
        let i = d.count - 1
        let start = d.first!.asDouble()
        let stop = d.last!.asDouble()
        var step = tickStep(start: start, stop: stop, count: count)
        step = tickStep(start: floor(start/step)*step, stop: ceil(stop/step)*step, count: count)
        d[0] = S(floor(start / step) * step)
        d[i] = S(ceil(stop / step) * step)
        _ = domain(d)
        return self
    }
}
