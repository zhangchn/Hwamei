//
//  LinearClosed.swift
//  Hwamei
//
//  Created by ZhangChen on 05/05/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation

public class LinearClosedCurve: LinearCurve {
    
    override public func areaStart() {
    }
    
    override public func areaEnd() {
    }

    override public func lineEnd() {
        if _point > 0 {
            _ = _context.closePath()
        }
    }
    override public func point(_ p: CGPoint) {
        if _point > 0 {
            _ = _context.line(to: p)
        } else {
            _point = 1
            _ = _context.move(to: p)
        }
    }
}
