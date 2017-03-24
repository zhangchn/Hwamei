//
//  Scale.swift
//  d3s
//
//  Created by ZhangChen on 24/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation

class Scale {
    class func linear() -> Scale {
        let scale = Continuous(deinterpolate: deinterpolateLinear, reinterpolate: interpolate)
        return Linear.linearish(scale: scale)
    }
}

func deinterpolateLinear<T: FloatingPoint>(a: T, b: T) -> (T) -> T {
    let d = b - a
    return d != 0 ? { x in (x - a) / d } : { _ in b }
}

let unit = [0, 1.0]

typealias Interpolator = (Double) -> Double
typealias InterpolateFunc = (Double, Double) -> Interpolator

func polymap(domain: [Double], range: [Double], deinterpolate: InterpolateFunc, reinterpolate: InterpolateFunc) -> Interpolator {
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

func bimap(domain: [Double], range: [Double], deinterpolate: InterpolateFunc, reinterpolate: InterpolateFunc) -> Interpolator {
    let d0 = domain[0], d1 = domain[1], r0 = range[0], r1 = range[1]
    var d : Interpolator!, r: Interpolator!
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

func deinterpolateClamp(_ deinterpolate: @escaping InterpolateFunc) -> InterpolateFunc {
    return { a, b in
        let d = deinterpolate(a, b)
        return { x in
            return x <= a ? 0 : (x >= b ? 1 : d(x))
        }
    }
}

func reinterpolateClamp(_ reinterpolate: @escaping InterpolateFunc) -> InterpolateFunc {
    return { a, b in
        let r = reinterpolate(a, b)
        return { t in
            return t <= 0 ? a : (t >= 1 ? b : r(t))
        }
    }
}



class Continuous: Scale {
    
    var _deinterpolate : InterpolateFunc
    var _interpolate : InterpolateFunc = d3s.interpolate
    
    var _reinterpolate : InterpolateFunc

    var _domain = unit
    var _range = unit
    var _input: Interpolator?
    var _output: Interpolator?
    var _clamp = false
    
    var _piecewise: ([Double], [Double], InterpolateFunc, InterpolateFunc) -> Interpolator
    
    
    init(deinterpolate deinterp: @escaping InterpolateFunc, reinterpolate reinterp: @escaping InterpolateFunc) {
        _deinterpolate = deinterp
        _reinterpolate = reinterp
        _piecewise = bimap
    }
    
    func invert(_ y: Double) -> Double {
        if _input == nil {
            _input = _piecewise(_range, _domain, _deinterpolate, _clamp ? reinterpolateClamp(_interpolate) : _interpolate)
        }
        return _input!(y)
    }
    
    func scale(_ x: Double) -> Double {
        if _output == nil {
            _output = _piecewise(_domain, _range, _clamp ? deinterpolateClamp(_deinterpolate) : _deinterpolate, _interpolate)
        }
        return _output!(x)
    }
    
    var domain: [Double] { get { return _domain } }
    
    func domain(_ d: () -> [Double]) -> Self {
        _domain = d()
        return rescale()
    }
    
    var range: [Double] { get { return _range } }
    func range(_ r: () -> [Double]) -> Self {
        _range = r()
        return rescale()
    }
    
    func domain(_ d: [Double]) -> Self {
        _domain = d
        return rescale()
    }
    
    func range(_ r: [Double]) -> Self {
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
        _piecewise = min(_domain.count, _range.count) > 2 ? polymap : bimap
        _output = nil
        _input = nil
        return self
    }
}

internal class Linear: Scale {
    class func linearish(scale: Continuous) -> Scale {
        
    }
}
