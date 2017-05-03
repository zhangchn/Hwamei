//
//  Line.swift
//  Hwamei
//
//  Created by ZhangChen on 28/04/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation

class Line {
    fileprivate var _x: (Any, Int, [Any]) -> CGFloat = {(p, _, _) -> CGFloat in (p as! CGPoint).x }
    fileprivate var _y: (Any, Int, [Any]) -> CGFloat = {(p, _, _) -> CGFloat in (p as! CGPoint).y }
    fileprivate var _defined: (Any?, Int, [Any?]) -> Bool = {(p, _, _) -> Bool in true }
    
    fileprivate var _context : Path?
    
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
    
    func line(_ data: [Any?]) -> Path {
        let buffer = _context ?? Path()
        var flag = false
        for (idx, datum) in data.enumerated() {
            if _defined(datum, idx, data) != flag {
                flag = !flag
                if flag {
                    // TODO: lineStart
                } else {
                    // TODO: lineEnd
                }
            }
            if flag {
                // TODO: output.point(_x(datum, idx, data), _y(datum, idx, data))
            }
        }
        
        if flag == false {
            // TODO: lineEnd
        }
        
        return buffer
    }
    
}
