//
//  Line.swift
//  Hwamei
//
//  Created by ZhangChen on 28/04/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation

class Line {
    fileprivate var _x: (Any, Int, [Any]) -> CGFloat = {(p, _, _) in (p as! CGPoint).x }
    fileprivate var _y: (Any, Int, [Any]) -> CGFloat = {(p, _, _) in (p as! CGPoint).y }
    fileprivate var _defined: (Any?, Int, [Any?]) -> Bool = {(p, _, _) in true }
    
    fileprivate var _context : Path?
    
    fileprivate var _curve : (Path) -> Curve = { context in
        return LinearCurve(context)
    }
    
    init(_ context: Path) {
        _context = context
    }
}

extension Line {
    
    func x(_ f: @escaping (Any, Int, [Any]) -> CGFloat) -> Self {
        _x = f
        return self
    }
    func y(_ f: @escaping (Any, Int, [Any]) -> CGFloat) -> Self {
        _y = f
        return self
    }
    
    
    
    func line(_ data: [Any]) -> Path {
        let buffer = _context ?? Path()
        let output = _curve(buffer)
        var flag = false
        for (idx, datum) in data.enumerated() {
            if _defined(datum, idx, data) != flag {
                flag = !flag
                if flag {
                    output.lineStart()
                } else {
                    output.lineEnd()
                }
            }
            if flag {
                output.point(x: _x(datum, idx, data),
                             y: _y(datum, idx, data))
            }
        }
        
        if flag == false {
            output.lineEnd()
        }
        
        return buffer
    }
    
}
