//
//  CurveLinear.swift
//  Hwamei
//
//  Created by ZhangChen on 05/05/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation

public class LinearCurve: AreaCurve {
    public init(_ context: Path) {
        _context = context
    }
    var _context: Path
    var _line: CGFloat = 0
    var _point: Int = 0
    public func areaStart() {
        _line = 0
    }
    public func areaEnd() {
        _line = .nan
    }
    
    public func lineStart() {
        _point = 0
    }
    
    public func lineEnd() {
        if _line > 0 || _line != 0  && _point == 1 {
            _ = _context.closePath()
        }
        _line = 1 - _line
    }
    public func point(_ p: CGPoint) {
        switch _point {
        case 0:
            _point = 1
            _ = _line > 0 ? _context.line(to: p) : _context.move(to: p)
        case 1:
            _point = 2
            _ = _context.line(to: p)
        default:
            _ = _context.line(to: p)
        }
    }
}
