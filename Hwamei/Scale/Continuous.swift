//
//  Continuous.swift
//  Hwamei
//
//  Created by ZhangChen on 24/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation

public class Continuous<S: ReversibleInterpolatable, T: ReversibleInterpolatable>: InvertibleScale {

    public var ticks: (([String : Any]) -> [S])? { get { return nil } }
    public var tickFormat: ((Int, String) -> FormatFunc)?  { get { return nil } }
    
    public typealias DomainType = S
    public typealias RangeType = T
    
    public typealias DeinterpolateRange     = (T, T) -> (T) -> Double
    public typealias InterpolateDomain      = (S, S) -> (Double) -> S
    public typealias InterpolateRange       = (T, T) -> (Double) -> T
    public typealias DeinterpolateDomain    = (S, S) -> (S) -> Double
    
    internal var _deinterpolateRange : DeinterpolateRange    = T.reverseInterpolate
    internal var _interpolateDomain : InterpolateDomain      //= S.interpolate
    internal var _interpolateRange : InterpolateRange        = T.interpolate
    internal var _deinterpolateDomain : DeinterpolateDomain  //= S.reverseInterpolate
    
    var _domain: [S] = [S.zero, S.one] // unit
    var _range: [T] = [T.zero, T.one] // unit
    var _input: ((T) -> S)?
    var _output: ((S) -> T)?
    var _clamp = false
    
    var _piecewise1 : ([S], [T], @escaping DeinterpolateDomain, @escaping InterpolateRange) -> (S) -> T
    var _piecewise2 : ([T], [S], @escaping DeinterpolateRange, @escaping InterpolateDomain) -> (T) -> S

//    public override init() {
//        _piecewise1 = Continuous.bimap
//        _piecewise2 = Continuous.bimap
//    }
    
    public init(deinterpolate deinterp: @escaping DeinterpolateDomain, reinterpolate reinterp: @escaping InterpolateDomain) {
        _deinterpolateDomain = deinterp
        _interpolateDomain = reinterp
        _piecewise1 = Continuous.bimap
        _piecewise2 = Continuous.bimap
    }
    
    public func invert(_ y: T) -> S {
        let input = _input ?? _piecewise2(_range, _domain, _deinterpolateRange, _clamp ? reinterpolateClamp(_interpolateDomain) : _interpolateDomain)
        return input(y)
    }
    
    public func scale(_ x: S) -> T {
        let output = _output ?? _piecewise1(_domain, _range, _clamp ? deinterpolateClamp(_deinterpolateDomain) : _deinterpolateDomain, _interpolateRange)
        return output(x)
    }
    
    public var domain: [S] { get { return _domain } }
    
    public func domain(_ d: () -> [S]) -> Self {
        _domain = d()
        return rescale()
    }
    
    public var range: [T] { get { return _range } }
    public func range(_ r: () -> [T]) -> Self {
        _range = r()
        return rescale()
    }
    
    public func domain(_ d: [S]) -> Self {
        _domain = d
        return rescale()
    }
    
    public func range(_ r: [T]) -> Self {
        _range = r
        return rescale()
    }
    
    public var clamp: Bool { get { return _clamp } }
    
    public func clamp(_ c: Bool) -> Self {
        _clamp = c
        return rescale()
    }
    
    //    func interpolate() -> InterpolateFunc {
    //        return _interpolate
    //    }
    
    public var interpolateRange : InterpolateRange { return _interpolateRange }
    public var interpolateDomain : InterpolateDomain { return _interpolateDomain }
    public var deinterpolateRange : DeinterpolateRange { return _deinterpolateRange }
    public var deinterpolateDomain : DeinterpolateDomain { return _deinterpolateDomain }
    
    public func interpolateRange(_ f: @escaping InterpolateRange) -> Self {
        _interpolateRange = f
        return rescale()
    }
    public func interpolateDomain(_ f: @escaping InterpolateDomain) -> Self {
        _interpolateDomain = f
        return rescale()
    }
    public func deinterpolateRange(_ f: @escaping DeinterpolateRange) -> Self {
        _deinterpolateRange = f
        return rescale()
    }
    public func deinterpolateDomain(_ f: @escaping DeinterpolateDomain) -> Self {
        _deinterpolateDomain = f
        return rescale()
    }
    public func rescale() -> Self {
        _piecewise1 = min(_domain.count, _range.count) > 2 ? Continuous.polymap : Continuous.bimap
        _piecewise2 = min(_domain.count, _range.count) > 2 ? Continuous.polymap : Continuous.bimap
        _output = nil
        _input = nil
        return self
    }
    
    class func polymap(domain: [S], range: [T], deinterpolate: @escaping DeinterpolateDomain, reinterpolate: @escaping InterpolateRange) -> (S) -> T {
        let j = min(domain.count, range.count) - 1
        let inversed = domain[j] < domain[0]
        let domain = inversed ? domain.reversed() : domain
        let range = inversed ? range.reversed() : range
        
        let d = (0..<j).map { deinterpolate(domain[$0], domain[$0 + 1])}
        let r = (0..<j).map { reinterpolate(range[$0], range[$0 + 1])}
        return { x in
            let i = bisect()(domain, x, 1, j) - 1
            return r[i](d[i](x))
        }
    }
    
    class func polymap(domain: [T], range: [S], deinterpolate: @escaping DeinterpolateRange, reinterpolate: @escaping InterpolateDomain) -> (T) -> S {
        let j = min(domain.count, range.count) - 1
        let inversed = domain[j] < domain[0]
        let domain = inversed ? domain.reversed() : domain
        let range = inversed ? range.reversed() : range
        
        let d = (0..<j).map { deinterpolate(domain[$0], domain[$0 + 1])}
        let r = (0..<j).map { reinterpolate(range[$0], range[$0 + 1])}
        return { x in
            let i = bisect()(domain, x, 1, j) - 1
            return r[i](d[i](x))
        }
    }
    
    class func bimap(domain: [S], range: [T], deinterpolate: @escaping DeinterpolateDomain, reinterpolate: @escaping InterpolateRange) -> (S) -> T {
        let d0 = domain[0], d1 = domain[1], r0 = range[0], r1 = range[1]
        var d : ((S) -> Double)!, r: ((Double) -> T)!
        if d1 < d0 {
            d = deinterpolate(d1, d0)
            r = reinterpolate(r1, r0)
        } else {
            d = deinterpolate(d0, d1)
            r = reinterpolate(r0, r1)
        }
        return { x in
            return r(d(x))
        }
    }
    class func bimap(domain: [T], range: [S], deinterpolate: @escaping DeinterpolateRange, reinterpolate: @escaping InterpolateDomain) -> (T) -> S {
        let d0 = domain[0], d1 = domain[1], r0 = range[0], r1 = range[1]
        var d : ((T) -> Double)!, r: ((Double) -> S)!
        if d1 < d0 {
            d = deinterpolate(d1, d0)
            r = reinterpolate(r1, r0)
        } else {
            d = deinterpolate(d0, d1)
            r = reinterpolate(r0, r1)
        }
        return { x in
            return r(d(x))
        }
    }
    
    func reinterpolateClamp(_ reinterpolate: @escaping InterpolateDomain) -> InterpolateDomain {
        return { a, b in
            let r = reinterpolate(a, b)
            return { t in
                return t <= 0 ? a : (t >= 1.0 ? b : r(t))
            }
        }
    }
    
    func deinterpolateClamp(_ deinterpolate: @escaping DeinterpolateDomain) -> DeinterpolateDomain {
        return { a, b in
            let d = deinterpolate(a, b)
            return { x in
                return x <= a ? 0 : (x >= b ? 1 : d(x))
            }
        }
    }

}
