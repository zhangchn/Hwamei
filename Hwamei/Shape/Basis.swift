//
//  Basis.swift
//  Hwamei
//
//  Created by ZhangChen on 05/05/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation

public class Basis: AreaCurve {
    
    public init(_ context: Path) {
        _context = context
    }
    var _context: Path
    var _line = false
    var _area = false
    var _point: Int = 0
    var _x0 = CGFloat(0)
    var _y0 = CGFloat(0)
    var _x1 = CGFloat(0)
    var _y1 = CGFloat(0)
    public func areaStart() {
        //_line = false
        _area = false
    }
    public func areaEnd() {
        //_line = .nan
        _area = true
    }
    
    public func lineStart() {
        _x0 = .nan
        _x1 = .nan
        _y0 = .nan
        _y1 = .nan
        
        _point = 0
    }
    
    public func lineEnd() {
        switch _point {
        case 2, 3:
            if _point ==  3 {
                addPoint(CGPoint(x: _x1, y: _y1))
            }
            _ = _context.line(to: CGPoint(x: _x1, y: _y1))
            
        default:
            break
        }
        
        if _line || (_area && _point == 1) {
            _ = _context.closePath()
        }
        _line = !_line
    }
    
    public func point(_ p: CGPoint) {
        switch _point {
        case 0:
            _point = 1
            _ = _line ? _context.line(to: p) : _context.move(to: p)
        case 1:
            _point = 2
        case 2:
            _point = 3
            _ = _context.line(to: CGPoint(x: (5 * _x0 + _x1) / 6, y: (5 * _y0 + _y1) / 6))
            addPoint(p)
        default:
            addPoint(p)
        }
        _x0 = _x1
        _y0 = _y1
        _x1 = p.x
        _y1 = p.y
    }

    func addPoint(_ p: CGPoint) {
        _ = _context.bezierCurve(withControl1: CGPoint(x: (2 * _x0 + _x1) / 3,
                                                       y: (2 * _y0 + _y1) / 3),
                                 control2: CGPoint(x: (_x0 + 2 * _x1) / 3,
                                                   y: (_y0 + 2 * _y1) / 3),
                                 to: CGPoint(x: (_x0 + 4 * _x1 + p.x) / 6,
                                             y: (_y0 + 4 * _y1 + p.y) / 6))
    }
}
