//
//  Cardinal.swift
//  Hwamei
//
//  Created by ZhangChen on 15/05/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation

public class Cardinal: AreaCurve {
    public init(_ context: Path, tension: CGFloat = 0) {
        _context = context
        _k = (1 - tension) / 6
    }
    
    var _context: Path
    var _line = false
    var _p0 = CGPoint.zero
    var _p1 = CGPoint.zero
    var _p2 = CGPoint.zero
    var _k : CGFloat
    var _point = 0
    
    public func areaStart() {
        _line = false
    }
    
    public func areaEnd() {
        // _line = .nan
    }
    
    public func lineStart() {
        _p0 = CGPoint(x: CGFloat.nan, y: CGFloat.nan)
        _p1 = _p0
        _p2 = _p1
        _point = 0
    }
    
    public func lineEnd() {
        switch _point {
        case 2:
            _ = _context.line(to: _p2)
        case 3:
            addPoint(_p1)
        default:
            break
        }
        if _line || (_line != false && _point == 1){
            _ = _context.closePath()
        }
        _line = !_line
    }
    
    public func point(_ p: CGPoint) {
        switch _point {
        case 0:
            _point = 1
            if _line {
                _ = _context.line(to: p)
            } else {
                _ = _context.move(to: p)
            }
        case 1:
            _point = 2
            _p1 = p
        case 2:
            _point = 3
            addPoint(p)
        default:
            addPoint(p)
        }
        _p0 = _p1
        _p1 = _p2
        _p2 = p
    }
    func addPoint(_ p: CGPoint) {
        _ = _context.bezierCurve(withControl1: CGPoint(x: _p1.x + _k * (_p2.x - _p0.x),
                                                       y: _p1.y + _k * (_p2.y - _p0.y)),
                                 control2: CGPoint(x: _p2.x + _k * (_p1.x - p.x),
                                                   y: _p2.y + _k * (_p1.y - p.y)),
                                 to: _p2)
    }

}
