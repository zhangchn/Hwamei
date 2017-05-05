//
//  Radial.swift
//  Hwamei
//
//  Created by ZhangChen on 05/05/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation

public class Radial: AreaCurve {
    public init(_ curve: AreaCurve) {
        _curve = curve
    }
    
    var _curve: AreaCurve
    
    public func areaStart() {
        return _curve.areaStart()
    }
    
    public func areaEnd() {
        return _curve.areaEnd()
    }
    
    public func lineStart() {
        return _curve.lineStart()
    }
    
    public func lineEnd() {
        return _curve.lineEnd()
    }
    
    public func point(_ p: CGPoint) {
        return _curve.point(p)
    }
}
