//
//  Log.swift
//  Hwamei
//
//  Created by ZhangChen on 27/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation

func deinterpolateLog(a: Double, b: Double) -> (Double) -> Double {
    let d = b / a
    if d == 1.0 {
        return Double.interpolate(a: a, b: b)
    }
    
    return {x in
        log( x / a) / d
    }
}
func reinterpolateLog(a: Double, b: Double) -> (Double) -> Double {
    return (a < 0) ? { t in
        pow(-b, t) * pow(-a, 1 - t)
        } : { t in
        pow(b, t) * pow(a, 1 - t)
    }
}

func logp(_ base: Double) -> (Double) -> Double {
    switch base {
    case 10:
        return log10
    case 2:
        return log2
    default:
        let b = log(base)
        return { log($0) / b }
    }
}

func powp(_ base: Double) -> (Double) -> Double {
    switch base {
    case M_E:
        return exp
    default:
        return { pow(base, $0) }
    }
}

func reflect(_ f: @escaping (Double) -> Double) -> (Double) -> Double {
    return {
        -f(-$0)
    }
}

public class Log<T: ReversibleInterpolatable>: Continuous<Double, T> {
    var _base: Double = 10
    var _logs: (Double) -> Double = log10
    var _pows: (Double) -> Double = powp(10)
    public init() {
        super.init(deinterpolate: deinterpolateLog, reinterpolate: reinterpolateLog)
    }
    
    
    override public func rescale() -> Self {
        _logs = logp(_base)
        _pows = powp(_base)
        if domain[0] < 0 {
            _logs = reflect(_logs)
            _pows = reflect(_pows)
        }
        return self
    }
    
    public var base: Double {
        get {
            return _base
        }
        set {
            _base = newValue
            _ = rescale()
        }
    }
    public func base(_ b: Double) -> Self {
        _base = b
        return rescale()
    }
    
    public func nice() -> Self {
        let niced = Hwamei.nice(domain: super.domain,
                                floor: { _pows(floor(_logs($0))) },
                                ceil: {_pows(ceil(_logs($0))) }
        )
        return domain(niced)
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

    public override var ticks : (([String: Any]) -> [Double])? {
        get {
            return { (arguments: [String: Any]) -> [Double] in
                let count: Int = (arguments["count"] as? Int) ?? 10
                return self.ticks(count: count)
            }
        }
    }

    func ticks(count: Int) -> [Double] {
        let d = domain
        let u = min(d.first!, d.last!)
        let v = max(d.first!, d.last!)
        var (i, j) = (_logs(u), _logs(v))
        var z : [Double] = []
        if remainder(_base, 1.0) == 0.0 && j - 1 < Double(count) {
            i = round(i) - 1
            j = round(j) + 1
            if u > 0 {
                while i  < j {
                    let p = _pows(i)
                    for k in 1..<Int(ceil(_base)) {
                        
                        let t = p * Double(k)
                        if t < u {
                            continue
                        } else if t > u {
                            break
                        }
                        z.append(t)
                    }
                    i += 1
                }
            } else {
                while i < j {
                    let p = _pows(i)
                    var k = base - 1
                    while k >= 1 {
                        let t = p * k
                        if t < u {
                            continue
                        } else if t > u {
                            break
                        }
                        z.append(t)
                        k -= 1
                    }
                    i += 1
                }
            }
        } else {
            z = Hwamei.ticks(start: i, stop: i, count: min(Int(j - i), count)).map(_pows)
        }
        
        if d.first! < d.last! {
            return z
        } else {
            return z.reversed()
        }
    }
}

