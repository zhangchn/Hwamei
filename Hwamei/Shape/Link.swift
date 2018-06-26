//
//  Link.swift
//  Hwamei
//
//  Created by ZhangChen on 18/05/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation

public protocol LinkSource {
    var source: CGPoint { get }
}

public protocol LinkTarget {
    var target: CGPoint { get }
}

public protocol LinkItem: LinkSource, LinkTarget {
    
}

public class Link {
    var _source: (CALayer, LinkSource, Int, [Any]) -> CGPoint = { (_, s, _, _) in s.source }
    var _target: (CALayer, LinkTarget, Int, [Any]) -> CGPoint = { (_, t, _, _) in t.target }
    var _x: (CALayer, CGPoint, Int, [Any]) -> CGFloat = { (_, p, _, _) in p.x }
    var _y: (CALayer, CGPoint, Int, [Any]) -> CGFloat = { (_, p, _, _) in p.y }
    var _curve: (Path, CGFloat, CGFloat, CGFloat, CGFloat) -> ()
    
    public init(curve: @escaping (Path, CGFloat, CGFloat, CGFloat, CGFloat) -> ()) {
        _curve = curve
    }
    
    public func link(_ layer: CALayer, _ datum: LinkItem, index: Int, data: [Any]) -> Path {
        let buffer = Path()
        let s = _source(layer, datum, index, data)
        let t = _target(layer, datum, index, data)
        _curve(buffer, _x(layer, s, index, data), _y(layer, s, index, data),
               _x(layer, t, index, data), _y(layer, t, index, data))
        return buffer
    }
    
    static func curveHorizontal(context: Path, x0: CGFloat, y0: CGFloat, x1: CGFloat, y1: CGFloat) {
        let xm = (x0 + x1) / 2
        _ = context.move(to: CGPoint(x: x0, y: y0))
            .bezierCurve(withControl1: CGPoint(x: xm, y: y0),
                         control2: CGPoint(x: xm, y: y1),
                         to: CGPoint(x: x1, y: y1))
    }
    
    static func curveVertical(context: Path, x0: CGFloat, y0: CGFloat, x1: CGFloat, y1: CGFloat) {
        let ym = (y0 + y1) / 2
        _ = context.move(to: CGPoint(x: x0, y: y0))
            .bezierCurve(withControl1: CGPoint(x: x0, y: ym),
                         control2: CGPoint(x: x1, y: ym),
                         to: CGPoint(x: x1, y: y1))
    }
    
    static func curveRadical(context: Path, r0: CGFloat, theta0: CGFloat, r1: CGFloat, theta1: CGFloat) {
        let theta = (theta0 + theta1) / 2
        let p0 = pointRadical(CGPoint(x: r0, y: theta0))
        let p1 = pointRadical(CGPoint(x: r0, y: theta))
        let p2 = pointRadical(CGPoint(x: r1, y: theta))
        let p3 = pointRadical(CGPoint(x: r1, y: theta1))
        _ = context.move(to: p0)
            .bezierCurve(withControl1: p1,
                         control2: p2,
                         to: p3)
    }
    
    class func linkHorizontal() -> Link {
        return Link(curve: curveHorizontal)
    }
    
    class func linkVertical() -> Link {
        return Link(curve: curveVertical)
    }
    
    class func linkRadical() -> Link {
        return Link(curve: curveRadical)
    }

}
