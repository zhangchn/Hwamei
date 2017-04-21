//
//  Sequential.swift
//  Hwamei
//
//  Created by ZhangChen on 06/04/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation

public class Sequential<S: Tickable, T>: LinearScale {
    public typealias DomainType = S
    public typealias RangeType = T
    var _domain: [S] = [0, 1]
    public var domain: [S] {
        get {
            return _domain
        }
        set {
            _domain = [newValue[0], newValue[1]]
        }
    }
    
    public func domain(_ d: [S]) -> Self {
        domain = d
        return self
    }
    
    var _clamp = false
    
    public init(_ interpolator: @escaping (S) -> T){
        _interpolator = interpolator
    }
    
    var _interpolator: (S) -> T
    
    public func scale(_ x: S) -> T {
        let t = (x - _domain[0]) / (_domain[1] - _domain[0])
        return _interpolator(_clamp ? max(0, min(1, t)) : t)
    }
    
    public func ticks(count: Int) -> [S] {
        let first = _domain.first!
        let last = _domain.last!
        return Hwamei.ticks(start: first, stop: last, count: count)
    }
    
    public var tickFormat: ((Int, String) -> FormatFunc)? {
        get {
            return {(count: Int, specifier: String) -> FormatFunc in
                return Hwamei.tickFormat(domain: self.domain,
                                         count: count,
                                         specifier: specifier)
            }
        }
    }
    
    public var ticks : (([String: Any]) -> [S])? {
        get {
            return { (arguments: [String: Any]) -> [S] in
                let count: Int = (arguments["count"] as? Int) ?? 10
                return self.ticks(count: count)
            }
        }
    }
    
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
