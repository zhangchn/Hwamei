//
//  Linear.swift
//  Hwamei
//
//  Created by ZhangChen on 24/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation


func deinterpolateLinear<T: FloatingPoint>(a: T, b: T) -> (T) -> T {
    let d = b - a
    return d != 0 ? { x in (x - a) / d } : { _ in b }
}

public protocol LinearScale: Scale {
    func nice(count: Int) -> Self
    func ticks(count: Int) -> [DomainType]
}

extension LinearScale {
    var ticks : (([String: Any]) -> [DomainType])? {
        get {
            return { (arguments: [String: Any]) -> [DomainType] in
                let count: Int = (arguments["count"] as? Int) ?? 10
                return self.ticks(count: count)
            }
        }
    }
}

public class Linear<S: ReversibleInterpolatable & Tickable, T: ReversibleInterpolatable>: Continuous<S,T>, LinearScale {
    typealias TickType = S
    
    public override init(deinterpolate deinterp: @escaping DeinterpolateDomain, reinterpolate reinterp: @escaping InterpolateDomain) {
        super.init(deinterpolate: deinterp, reinterpolate: reinterp)
    }
    public init() {
        super.init(deinterpolate: S.reverseInterpolate, reinterpolate: S.interpolate)
    }
    
    public func ticks(count: Int) -> [S] {
        let first = _domain.first!
        let last = _domain.last!
        return Hwamei.ticks(start: first, stop: last, count: count)
    }
    
    public override var tickFormat: ((Int, String) -> FormatFunc)? {
        get {
            return {(count: Int, specifier: String) -> FormatFunc in
                return Hwamei.tickFormat(domain: self.domain,
                                         count: count,
                                         specifier: specifier)
            }
        }
    }
    
//    public func tickFormat(count: Int, specifier: String = "") -> FormatFunc {
//        return Hwamei.tickFormat(domain: _domain.map { $0.tickValue() },
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
        return domain(d)
    }
}
