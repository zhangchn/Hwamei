//
//  BasisClosed.swift
//  Hwamei
//
//  Created by ZhangChen on 05/05/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation

public class BasisClosed: Basis {
    var _x2: CGFloat = 0
    var _x3: CGFloat = 0
    var _x4: CGFloat = 0
    var _y2: CGFloat = 0
    var _y3: CGFloat = 0
    var _y4: CGFloat = 0
    
    public override func areaStart() {
    }
    public override func areaEnd() {
    }
    public override func lineStart() {
        _x0 = .nan
        _x1 = .nan
        _x2 = .nan
        _x3 = .nan
        _x4 = .nan
        _y0 = .nan
        _y1 = .nan
        _y2 = .nan
        _y3 = .nan
        _y4 = .nan
        
        _point = 0
    }
    
    public override func lineEnd() {
        switch _point {
        case 1:
            _ = _context.move(to: CGPoint(x:_x2, y: _y2))
            _ = _context.closePath()
            
        case 2:
            _ = _context.move(to: CGPoint(x:(_x2 + 2 * _x3) / 3, y: (_y2 + 2 * _y3) / 3))
            _ = _context.line(to: CGPoint(x:(_x3 + 2 * _x2) / 3, y: (_y3 + 2 * _y2) / 3))
            _ = _context.closePath()
           
        case 3:
            point(x: _x2, y: _y2)
            point(x: _x3, y: _y3)
            point(x: _x4, y: _y4)
        default:
            break
            
        }
    }
    public override func point(_ p: CGPoint) {
        let x = p.x
        let y = p.y
        switch _point {
        case 0:
            _point = 1
            _x2 = x
            _y2 = y
            
        case 1:
            _point = 2
            _x3 = x
            _y3 = y
        case 2:
            _point = 3
            _x4 = x
            _y4 = y
            _ = _context.move(to: CGPoint(x: (_x0 + 4 * _x1 + x) / 6,
                                          y: (_y0 + 4 * _y1 + y) / 6))
        default:
            addPoint(p)
        }
        _x0 = _x1
        _x1 = x
        _y0 = _y1
        _y1 = y
    }
}
