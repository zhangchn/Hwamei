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
    typealias TickType = S
    
    public override init(deinterpolate deinterp: @escaping DeinterpolateDomain, reinterpolate reinterp: @escaping InterpolateDomain) {
        super.init(deinterpolate: deinterp, reinterpolate: reinterp)
    }
    public init() {
        super.init(deinterpolate: S.reverseInterpolate, reinterpolate: S.interpolate)
    }
    public override var ticks : (([String: Any]) -> [S])? {
        get {
            return { (arguments: [String: Any]) -> [S] in
                let count: Int = (arguments["count"] as? Int) ?? 10
                return self.ticks(count: count)
            }
        }
    }
    
    public func ticks(count: Int) -> [S] {
        let first = _domain.first!
        let last = _domain.last!
        return d3s.ticks(start: first, stop: last, count: count)
    }
    
    public override var tickFormat: ((Int, String) -> FormatFunc)? {
        get {
            return {(count: Int, specifier: String) -> FormatFunc in
                return d3s.tickFormat(domain: self.domain,
                                      count: count,
                                      specifier: specifier)
            }
        }
    }
    
//    public func tickFormat(count: Int, specifier: String = "") -> FormatFunc {
//        return d3s.tickFormat(domain: _domain.map { $0.tickValue() },
//                              count: count,
//                              specifier: specifier)
//    }
    
    public func nice(count: Int = 10) -> Self {
        var d = domain
        let i = d.count - 1
        let start = d.first!
        let stop = d.last!
        var step = tickStep(start: start, stop: stop, count: count)
        step = tickStep(start: floor(start/step)*step, stop: ceil(stop/step)*step, count: count)
        d[0] = floor(start / step) * step
        d[i] = ceil(stop / step) * step
        _ = domain(d)
        return self
    }
}
