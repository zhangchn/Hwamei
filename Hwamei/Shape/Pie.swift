//
//  Pie.swift
//  Hwamei
//
//  Created by ZhangChen on 04/05/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation

public class Pie<S: Comparable> {
    public typealias SliceTuple = (S, CGFloat, Int, Arc.ArcParameters)
    var _value: (S, Int, [S]) -> CGFloat = { x, _, _ in x as! CGFloat }
    var _sortValues: ((CGFloat, CGFloat) -> Bool)? = (<)
    var _sort: ((S, S) -> Bool)? = (<)

    var _startAngle : ([S]) -> CGFloat = { _ in 0 }
    var _endAngle : ([S]) -> CGFloat = { _ in .tau }
    var _padAngle : ([S]) -> CGFloat = { _ in 0 }
    public init() {
        
    }
    public func pie(_ data: [S]) -> [SliceTuple] {
        let n = data.count
        var a0 = _startAngle(data)
        let da = min(.tau, max(-.tau, _endAngle(data) - a0))
        let p = min(abs(da) / CGFloat(n), _padAngle(data))
        let pa = p * (da < 0 ? -1 : 1)
        
        var index = Array(0..<n)
        var arcs : [(S, CGFloat, Int, Arc.ArcParameters)] = []
        
        let vs = data.enumerated().map { (idx, d) in _value(d, idx, data) }
        let sum = vs.filter { $0 > 0 } .reduce(CGFloat(0)) { (acc, v) -> CGFloat in
            acc + v
        }
        if let sv = _sortValues {
            index.sort() { (i, j) in
                sv(vs[i], vs[j])
            }
        } else if let sd = _sort {
            index.sort() { (i, j) in
                sd(data[i], data[j])
            }
        }
        
        var a1: CGFloat
        let k = sum != 0 ? (da - CGFloat(n) * pa) / sum : 0
        
        for i in 0..<n {
            let j = index[i]
            let v = vs[j]
            a1 = a0 + (v > 0 ? v * k : 0) + pa
            arcs.append((data[j],
                         v,
                         i,
                         [
                            .startAngle: a0,
                            .endAngle: a1,
                            .padAngle: p
                ]))
            a0 = a1
        }
        return arcs
    }
    
    public func value(_ f: @escaping (S, Int, [S]) -> CGFloat) -> Pie {
        _value = f
        return self
    }
    
    public func sortValues(_ f: ((CGFloat, CGFloat) -> Bool)?) -> Pie {
        _sortValues = f
        return self
    }
    public func sort(_ f: ((S, S) -> Bool)?) -> Pie {
        _sort = f
        return self
    }
    
    public func padAngle(_ f: @escaping ([S]) -> CGFloat) -> Pie {
        _padAngle = f
        return self
    }
    
    public func padAngle(_ v: CGFloat) -> Pie {
        _padAngle = {_ in v }
        return self
    }
}

extension Arc {
    public func arc<S: Comparable>(_ slice: Pie<S>.SliceTuple) -> Path {
        return arc(slice.3)
    }
}
