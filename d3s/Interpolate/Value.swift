//
//  Value.swift
//  d3s
//
//  Created by ZhangChen on 23/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation

public func interpolate<V: FloatingPoint>(a: V, b: V) -> (V) -> V {
    let d = b - a
    return { t in
        a + d * t
    }
}

public func interpolate<T: FloatingPoint>(a: [T], b: [T]) -> (T) -> [T] {
    let m = a.count < b.count ? a + b[a.count ..< b.count] : a
    let n = a.count > b.count ? b + a[b.count ..< a.count] : b
    
    return { t in
        zip(m, n).map({ (x, y) -> T in
            x + (y - x) * t
        })
    }
}

public func interpolate<K: Hashable, V: FloatingPoint>(a: [K: V], b: [K: V]) -> (V) -> [K: V] {
    var m = a, n = b
    for (k, v) in b {
        if a[k] == nil {
            m[k] = v
        }
    }
    for (k, v) in a {
        if b[k] == nil {
            n[k] = v
        }
    }
    
    return { t in
        var x : [K: V] = Dictionary<K, V>(minimumCapacity: m.count)
        for (k, v) in m {
            x[k] = v + (n[k]! - v) * t
        }
        return x
    }
}

public func interpolate(a: CGColor, b: CGColor) -> (CGFloat) -> CGColor? {
    if let model = a.colorSpace?.model {
        switch model {
        case .rgb:
            return interpolateGamma(a: a, b: b)
        case .lab:
            return interpolateNoGamma(a: a, b: b)
        case .monochrome:
            return interpolateNoGamma(a: a, b: b)
        default:
            return { _ in nil }
        }
    } else {
        return {_ in nil }
    }
}

func linearInterpolate(a: CGFloat, d: CGFloat) -> (CGFloat) -> CGFloat {
    return { t in
        a + t * d
    }
}

func exponentialInterpolate(a: CGFloat, b: CGFloat, y: CGFloat) -> (CGFloat) -> CGFloat {
    let m = pow(a, y),
    n = pow(b, y) - m,
    p = 1 / y
    return { t in
        return pow(m + t * n, p)
    }
}

public func nogammaInterpolate(a: CGFloat, b: CGFloat) -> (CGFloat) -> CGFloat {
    let d = b - a
    return d != 0 ? linearInterpolate(a: a, d: d) : { _ in
        a.isNaN ? b : a
    }
}
public func gammaInterpolate(y: CGFloat) -> (CGFloat, CGFloat) -> (CGFloat) -> CGFloat {
    if y == 1.0 {
        return nogammaInterpolate
    } else {
        return { a, b -> (CGFloat) -> CGFloat in
            return b - a != 0 ? exponentialInterpolate(a: a, b: b, y: y) : {_ in
                a.isNaN ? b : a
            }
        }
    }
}

public func interpolateGamma(a: CGColor, b: CGColor, gamma y: CGFloat = 1.0) -> (CGFloat) -> CGColor? {
    let g = gammaInterpolate(y: y)
    return { t in
        var components = [CGFloat]()
        for x in 0..<a.numberOfComponents {
            let c = g(a.components![x], b.components![x])(t)
            components.append(c)
        }
        let result = CGColor.init(colorSpace: a.colorSpace!, components: &components)
        return result
    }
}

public func interpolateNoGamma(a: CGColor, b: CGColor) -> (CGFloat) -> CGColor? {
    return { t in
        var components = [CGFloat]()
        for x in 0..<a.numberOfComponents {
            let c = nogammaInterpolate(a: a.components![x], b: b.components![x])(t)
            components.append(c)
        }
        let result = CGColor.init(colorSpace: a.colorSpace!, components: &components)
        return result
    }
}
