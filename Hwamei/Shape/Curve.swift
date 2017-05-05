//
//  Curve.swift
//  Hwamei
//
//  Created by ZhangChen on 05/05/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation

public protocol Curve {
    func lineStart()
    func lineEnd()
    func point(_ p: CGPoint)
}

public protocol AreaCurve: Curve {
    func areaStart()
    func areaEnd()
}

public extension Curve {
    public func point(x: CGFloat, y: CGFloat) {
        point(CGPoint(x: x, y: y))
    }
    
    public func point(a: CGFloat, r: CGFloat) {
        #if os(iOS)
            // flipped by default
            let sign = -1
        #else
            let sign = 1
        #endif
        point(CGPoint(x: r * sin(a), y: r * CGFloat(sign) * cos(a)))
    }
}
