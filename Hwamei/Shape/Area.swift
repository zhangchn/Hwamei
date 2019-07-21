//
//  Area.swift
//  Hwamei
//
//  Created by ZhangChen on 17/05/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation

public class Area {
    fileprivate var _x0: (Any, Int, [Any]) -> CGFloat = {(p, _, _) in (p as! CGPoint).x }
    fileprivate var _y0: (Any, Int, [Any]) -> CGFloat = {(_, _, _) in CGFloat(0) }
    fileprivate var _x1: (Any, Int, [Any]) -> CGFloat = {(p, _, _) in (p as! CGPoint).x }
    fileprivate var _y1: (Any, Int, [Any]) -> CGFloat = {(p, _, _) in (p as! CGPoint).y }
    fileprivate var _defined: (Any?, Int, [Any?]) -> Bool = {(p, _, _) in true }
    
    fileprivate var _context : Path?
    
    fileprivate var _curve : (Path) -> AreaCurve = { context in
        return LinearCurve(context)
    }
    
    public init(_ context: Path) {
        _context = context
    }

}

public extension Area {
    
    func x0(_ f: @escaping (Any, Int, [Any]) -> CGFloat) -> Self {
        _x0 = f
        return self
    }
    func y0(_ f: @escaping (Any, Int, [Any]) -> CGFloat) -> Self {
        _y0 = f
        return self
    }
    func x1(_ f: @escaping (Any, Int, [Any]) -> CGFloat) -> Self {
        _x0 = f
        return self
    }
    func y1(_ f: @escaping (Any, Int, [Any]) -> CGFloat) -> Self {
        _y0 = f
        return self
    }
    func curve(_ f: @escaping(Path) -> AreaCurve) -> Self {
        _curve = f
        return self
    }
    func defined(_ f: @escaping(Any?, Int, [Any?]) -> Bool) -> Self {
        _defined = f
        return self
    }
    func area(_ data: [Any]) -> Path {
        let buffer = _context ?? Path()
        let output = _curve(buffer)
        var flag = false
        var segmentStart = -1
        var pz = [CGPoint](repeating: .zero, count: data.count)
        for (idx, datum) in data.enumerated() {
            
            if _defined(datum, idx, data) != flag {
                flag = !flag
                if flag {
                    segmentStart = idx
                    output.areaStart()
                    output.lineStart()
                } else {
                    output.lineEnd()
                    output.lineStart()
                    for k in (segmentStart..<idx).reversed() {
                        output.point(pz[k])
                    }
                    output.lineEnd()
                    output.areaEnd()
                }
            }
                
            if flag {
                pz[idx] = CGPoint(x: _x0(datum, idx, data), y: _y0(datum, idx, data))
                output.point(x: _x1(datum, idx, data), y: _y1(datum, idx, data))
            }
        }
        
        //assert(flag)
        
        output.lineEnd()
        output.lineStart()
        for k in (segmentStart..<data.count).reversed() {
            output.point(pz[k])
        }
        output.lineEnd()
        output.areaEnd()
        

        return buffer
    }
}
