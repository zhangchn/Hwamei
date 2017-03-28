//
//  Quantize.swift
//  d3s
//
//  Created by ZhangChen on 28/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation

public class Quantize: Linear<Double, Double> {
    var x0: Double = 0
    var x1: Double = 1
    var n = 1
    
    public init() {
        super.init(deinterpolate: deinterpolateLinear, reinterpolate: interpolateFloat)
        _ = domain([0.5])
        _ = range([0, 1])
    }
    
    public override func scale(_ x: Double) -> Double {
        return _range[bisect()(_domain, x, 0, n)]
    }
    
    override public func rescale() -> Self {
        _domain = (0 ..< n).map { (i: Int) -> Double in
            let numerator = Double(i + 1) * x1 - Double(i - n) * x0
            let denominator = Double(n + 1)
            return numerator / denominator
        }
        return self
    }
    
    public override var domain: [Double] {
        get { return [x0, x1] }
    }
    public override func domain(_ d: [Double]) -> Self {
        x0 = d[0]
        x1 = d[1]
        return rescale()
    }
    
    public override func domain(_ d: () -> [Double]) -> Self {
        return domain(d())
    }
    
    public override func range(_ r: [Double]) -> Self {
        _range = r
        n = _range.count - 1
        return rescale()
    }
    
    public override func range(_ r: () -> [Double]) -> Self {
        return range(r())
    }
    
    public func invert(extent y: Double) -> [Double] {
        if let i = _range.index(of: y) {
            if i < 1 {
                return [x0, _domain[0]]
            } else if i >= n {
                return [_domain[n - 1], x1]
            } else {
                return [_domain[i - 1], _domain[i]]
            }
        } else {
            return [.nan, .nan]
        }
    }
}
