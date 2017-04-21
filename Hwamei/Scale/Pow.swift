//
//  Pow.swift
//  Hwamei
//
//  Created by ZhangChen on 25/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation

func raise(_ x: Double, _ exponent: Double)-> Double {
    return x < 0 ? -pow(-x, exponent) : pow(x, exponent)
}



func interpolatePow(exponent: Double) -> (Double, Double) -> (Double) -> Double {
    if exponent == 1.0 {
        return Double.interpolate
    }
    return {a, b in
        let m = raise(a, exponent)
        let n = raise(b, exponent) - m
        
        return { t in raise(m + n * t, 1 / exponent) }
    }
}
func deinterpolatePow(exponent: Double) -> (Double, Double) -> (Double) -> Double {
    if exponent == 1.0 {
        return Double.reverseInterpolate
    }
    return {a, b in
        let n = raise(b, exponent), m = raise(a, exponent)
        if (n - m) != 0 {
            return { x in (raise(x, exponent) - m) / n }
        } else {
            return { _ in n }
        }
    }
}

public class Power<T: ReversibleInterpolatable>: Linear<Double, T> {

    var _exponent: Double
    public var exponent: Double { get { return _exponent } }
    public func exponent(_ e: Double) -> Self {
        _exponent = e
        _deinterpolateDomain = deinterpolatePow(exponent: _exponent)
        _interpolateDomain = interpolatePow(exponent: _exponent)
        return rescale()
    }
    public init(exponent: Double = 1) {
        _exponent = exponent
        super.init(deinterpolate: deinterpolatePow(exponent: _exponent), reinterpolate: interpolatePow(exponent: _exponent))
    }
    
}
