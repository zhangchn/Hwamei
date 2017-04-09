//
//  Path.swift
//  d3s
//
//  Created by ZhangChen on 22/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation

public class Path {
    var _path : CGMutablePath
    public init(_ cgPath: CGPath) {
        _path = cgPath.mutableCopy()!
    }
    
    public init(_ start: CGPoint) {
        _path = CGMutablePath()
        _path.move(to: start)
    }
    
    public init() {
        _path = CGMutablePath()
    }
    
    public func copy() -> Path {
        return Path(_path.copy()!)
    }
    
    public func move(to point: CGPoint) -> Path {
        _path.move(to: point)
        return self
    }
    
    public func closePath() -> Path {
        _path.closeSubpath()
        return self
    }
    
    public func line(to point: CGPoint) -> Path {
        _path.addLine(to: point)
        return self
    }
    
    public func quadraticCurve(with controlPoint:CGPoint, to point: CGPoint) -> Path {
        _path.addQuadCurve(to: point, control: controlPoint)
        return self
    }
    
    public func bezierCurve(withControl1 control1:CGPoint, control2: CGPoint, to point: CGPoint) -> Path {
        _path.addCurve(to: point, control1: control1, control2: control2)
        return self
    }
    
    public func arc(toPoint1 point1: CGPoint, point2: CGPoint, radius: CGFloat) -> Path {
        _path.addArc(tangent1End: point1, tangent2End: point2, radius: radius)
        return self
    }
    
    public func arc(center: CGPoint, radius: CGFloat, start: CGFloat, end: CGFloat, anticlockwise: Bool = false) -> Path {
        _path.addArc(center: center, radius: radius, startAngle: start, endAngle: end, clockwise: anticlockwise)
        return self
    }
    
    public func rect(_ rect:CGRect) -> Path {
        _path.addRect(rect)
        return self
    }
    
    public var path: CGPath {
        get { return _path as CGPath }
    }
}
