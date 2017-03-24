//
//  Continuous.swift
//  d3s
//
//  Created by ZhangChen on 24/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation

public class Continuous<S: ReversibleInterpolatable, T: Interpolatable>: Scale<S> {
    //    typealias Interpolator = (Double) -> S
    //    typealias Deinterpolator = (S) -> Double
    //    typealias Reinterpolator = (Double) -> T
    //    typealias Dereinterpolator = (T) -> Double
    
    public typealias DeinterpolateFunc      = (T, T) -> (T) -> Double
    public typealias ReinterpolateFunc      = (S, S) -> (Double) -> S
    public typealias InterpolateFunc        = (T, T) -> (Double) -> T
    public typealias DereinterpolateFunc    = (S, S) -> (S) -> Double
    
    var _deinterpolate : DeinterpolateFunc
    var _reinterpolate : ReinterpolateFunc
    
    var _interpolate        : InterpolateFunc = T.interpolate
    var _counterinterpolate : DereinterpolateFunc = S.reverseInterpolate
    
    var _domain: [S] = [S.zero, S.one] // unit
    var _range: [T] = [T.zero, T.one] // unit
    var _input: ((T) -> S)?
    var _output: ((S) -> T)?
    var _clamp = false
    
    var _piecewise1 : ([S], [T], @escaping (S, S) -> (S) -> Double, @escaping (T, T) -> (Double) -> T) -> (S)->T
    var _piecewise2 : ([T], [S], @escaping (T, T) -> (T) -> Double, @escaping (S, S) -> (Double) -> S) -> (T) -> S
    
    public init(deinterpolate deinterp: @escaping DeinterpolateFunc, reinterpolate reinterp: @escaping ReinterpolateFunc) {
        _deinterpolate = deinterp
        _reinterpolate = reinterp
        _piecewise1 = Continuous.bimap
        _piecewise2 = Continuous.bimap
    }
    
    func invert(_ y: T) -> S {
        if _input == nil {
            _input = _piecewise2(_range, _domain, _deinterpolate, _clamp ? reinterpolateClamp(_reinterpolate) : _reinterpolate)
        }
        return _input!(y)
    }
    
    public func scale(_ x: S) -> T {
        if _output == nil {
            _output = _piecewise1(_domain, _range, _clamp ? deinterpolateClamp(_counterinterpolate) : _counterinterpolate, _interpolate)
        }
        return _output!(x)
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
    
    var clamp: Bool { get { return _clamp } }
    
    func clamp(_ c: Bool) -> Self {
        _clamp = c
        return rescale()
    }
    
    //    func interpolate() -> InterpolateFunc {
    //        return _interpolate
    //    }
    
    func interpolate(_ f: @escaping InterpolateFunc) -> Self {
        _interpolate = f
        return rescale()
    }
    
    func rescale() -> Self {
        _piecewise1 = min(_domain.count, _range.count) > 2 ? Continuous.polymap : Continuous.bimap
        _piecewise2 = min(_domain.count, _range.count) > 2 ? Continuous.polymap : Continuous.bimap
        _output = nil
        _input = nil
        return self
    }
    
    class func polymap(domain: [S], range: [T], deinterpolate: @escaping (S, S) -> (S) -> Double, reinterpolate: @escaping (T, T) -> (Double) -> T) -> (S) -> T {
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
    
    class func polymap(domain: [T], range: [S], deinterpolate: @escaping (T, T) -> (T) -> Double, reinterpolate: @escaping (S, S) -> (Double) -> S) -> (T) -> S {
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
    
    class func bimap(domain: [S], range: [T], deinterpolate: @escaping (S, S) -> (S) -> Double, reinterpolate: @escaping (T, T) ->(Double) -> T) -> (S) -> T {
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
    class func bimap(domain: [T], range: [S], deinterpolate: @escaping (T, T) -> (T) -> Double, reinterpolate: @escaping (S, S) ->(Double) -> S) -> (T) -> S {
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
    
    func reinterpolateClamp(_ reinterpolate: @escaping ReinterpolateFunc) -> ReinterpolateFunc {
        return { a, b in
            let r = reinterpolate(a, b)
            return { t in
                return t <= 0 ? a : (t >= 1.0 ? b : r(t))
            }
        }
    }
    
    func deinterpolateClamp(_ deinterpolate: @escaping DereinterpolateFunc) -> DereinterpolateFunc {
        return { a, b in
            let d = deinterpolate(a, b)
            return { x in
                return x <= a ? 0 : (x >= b ? 1 : d(x))
            }
        }
    }

}
