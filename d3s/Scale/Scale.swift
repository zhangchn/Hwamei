//
//  Scale.swift
//  d3s
//
//  Created by ZhangChen on 24/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation

public class Scale<T: Interpolatable> {
//    class func linear() -> Scale<T> {
//        let scale = Continuous(deinterpolate: deinterpolateLinear, reinterpolate: d3s.interpolate)
//        return Linear.linearish(scale: scale)
//    }
}

func deinterpolateLinear<T: FloatingPoint>(a: T, b: T) -> (T) -> T {
    let d = b - a
    return d != 0 ? { x in (x - a) / d } : { _ in b }
}

let unit = [0, 1.0]



//func polymap<P: Interpolatable, Q: Interpolatable>(domain: [P], range: [Q], deinterpolate: @escaping (P, P) -> (P) -> Double, reinterpolate: @escaping (Q, Q) -> (Double) -> Q) -> (P) -> Q {
//    let j = min(domain.count, range.count) - 1
//    let inversed = domain[j] < domain[0]
//    let domain = inversed ? domain.reversed() : domain
//    let range = inversed ? range.reversed() : range
//    
//    let d = (0..<j).map { deinterpolate(domain[$0], domain[$0 + 1])}
//    let r = (0..<j).map { reinterpolate(range[$0], range[$0 + 1])}
//    return { x in
//        let i = bisect()(domain, x, 1, j) - 1
//        return r[i](d[i](x))
//    }
//}
//
//func bimap<P: Interpolatable, Q: Interpolatable>(domain: [P], range: [Q], deinterpolate: @escaping (P, P) -> (P) -> Double, reinterpolate: @escaping (Q, Q) ->(Double) -> Q) -> (P) -> Q {
//    let d0 = domain[0], d1 = domain[1], r0 = range[0], r1 = range[1]
//    var d : ((P) -> Double)!, r: ((Double) -> Q)!
//    if d1 < d0 {
//        d = deinterpolate(d1, d0)
//        r = reinterpolate(r1, r0)
//    } else {
//        d = deinterpolate(d0, d1)
//        r = reinterpolate(r0, r1)
//    }
//    return { x in
//        return r(d(x))
//    }
//}

//func deinterpolateLinear<P: Interpolatable>(a: P, b: P) -> (P) -> Double {
//    let m = 2 * a
//    let n = b - m
//    
//}


