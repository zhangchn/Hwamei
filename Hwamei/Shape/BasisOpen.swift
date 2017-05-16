//
//  BasisOpen.swift
//  Hwamei
//
//  Created by ZhangChen on 15/05/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation

public class BasisOpen: Basis {
    public override func lineEnd() {
        if _line || _line != false && _point == 3 {
            _ = _context.closePath()
        }
        _line = !_line
    }
    
    public override func point(_ p: CGPoint) {
        switch _point {
        case 0:
            _point = 1
        case 1:
            _point = 2
        case 2:
            _point = 3
            _x0 = (_x0 + 4 * _x1 + p.x) / 6
            _y0 = (_y0 + 4 * _y1 + p.y) / 6
            if _line {
                _ = _context.line(to: CGPoint(x: _x0, y: _y0))
            } else {
                _ = _context.move(to: CGPoint(x: _x0, y: _y0))
            }
        case 3:
            _point = 4
            addPoint(p)
        default:
            addPoint(p)
        }
        _x0 = _x1
        _y0 = _y1
        _x1 = p.x
        _y1 = p.y
 
    }
}
