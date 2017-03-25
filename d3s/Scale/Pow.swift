//
//  Pow.swift
//  d3s
//
//  Created by ZhangChen on 25/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation

func raise(_ x: Double, _ exponent: Double)-> Double {
    return x < 0 ? -pow(-x, exponent) : pow(x, exponent)
}




class Pow: Linear<Double, Double> {
    func interpolateRange(a: Double, b: Double) -> (Double) -> Double {
        let m = raise(a, _exponent)
        let n = raise(b, _exponent) - m
        
        return { t in raise(m + n * t, 1 / self._exponent) }
    }

    func deinterpolateDomain(a: Double, b: Double) -> (Double) -> Double {
        let n = raise(b, _exponent), m = raise(a, _exponent)
        if (n - m) != 0 {
            return { x in (raise(x, self._exponent) - m) / n }
        } else {
            return { _ in n }
        }
    }
    var _exponent: Double
    init(exponent: Double = 1) {
        _exponent = exponent
        super.init()
        _interpolateRange = interpolateRange
        _deinterpolateDomain = deinterpolateDomain
    }
    
}
