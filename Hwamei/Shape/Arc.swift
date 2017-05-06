//
//  Arc.swift
//  Hwamei
//
//  Created by ZhangChen on 22/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import CoreGraphics


//let epsilon: CGFloat = 1e-12
//let tau: CGFloat = .pi * 2

extension CGFloat {
    static let tau: CGFloat = .pi * 2
    static let epsilon: CGFloat = 1e-12
}
extension Double {
    static let tau: Double = .pi * 2
    static let epsilon: Double = 1e-12
}

func intersect(_ x0: CGFloat, _ y0: CGFloat, _ x1: CGFloat, _ y1: CGFloat,
               _ x2: CGFloat, _ y2: CGFloat, _ x3: CGFloat, _ y3: CGFloat) -> CGPoint {
    let x10 = x1 - x0, y10 = y1 - y0,
    x32 = x3 - x2, y32 = y3 - y2,
    t = (x32 * (y0 - y2) - y32 * (x0 - x2)) / (y32 * x10 - x32 * y10)
    return CGPoint(x: x0 + t * x10, y: y0 + t * y10);
}

func cornerTangents(x0: CGFloat, y0: CGFloat,
                    x1: CGFloat, y1: CGFloat,
                    r1: CGFloat, rc: CGFloat,
                    cw: Bool) -> (CGFloat, CGFloat, CGFloat, CGFloat, CGFloat, CGFloat) {
    var x01 = x0 - x1,
    y01 = y0 - y1,
    lo = (cw ? rc : -rc) / sqrt(x01 * x01 + y01 * y01),
    ox = lo * y01,
    oy = -lo * x01,
    x11 = x0 + ox,
    y11 = y0 + oy,
    x10 = x1 + ox,
    y10 = y1 + oy,
    x00 = (x11 + x10) / 2,
    y00 = (y11 + y10) / 2,
    dx = x10 - x11,
    dy = y10 - y11,
    d2 = dx * dx + dy * dy,
    r = r1 - rc,
    D = x11 * y10 - x10 * y11,
    d = (dy < 0 ? -1 : 1) * sqrt(max(0, r * r * d2 - D * D)),
    cx0 = (D * dy - dx * d) / d2,
    cy0 = (-D * dx - dy * d) / d2,
    cx1 = (D * dy + dx * d) / d2,
    cy1 = (-D * dx + dy * d) / d2,
    dx0 = cx0 - x00,
    dy0 = cy0 - y00,
    dx1 = cx1 - x00,
    dy1 = cy1 - y00;
    
    // Pick the closer of the two intersection points.
    // TODO Is there a faster way to determine which intersection to use?
    if (dx0 * dx0 + dy0 * dy0 > dx1 * dx1 + dy1 * dy1) {
        cx0 = cx1
        cy0 = cy1
    }
    
    return (cx0, cy0, -ox, -oy, cx0 * (r1 / r - 1), cy0 * (r1 / r - 1))
}

public class Arc {
    public enum ArcParameter {
        case innerRadius
        case outerRadius
        case startAngle
        case endAngle
        case cornerRadius
        case padAngle
        case padRadius
    }
    public typealias ArcParameters = [ArcParameter: CGFloat]
    public typealias ArcFunc1 = ([ArcParameter: CGFloat]) -> CGFloat
    
    internal var constant: (CGFloat) -> ArcFunc1 = { v in { _ in v }}
    
    var _innerRadius: ArcFunc1 = { params in
        return params[.innerRadius] ?? 0
    }
    
    var _outerRadius: ArcFunc1 = { params in
        return params[.outerRadius] ?? 0
    }
    
    var _startAngle: ArcFunc1 = { params in
        return params[.startAngle] ?? 0
    }
    var _endAngle: ArcFunc1 = { params in
        return params[.endAngle] ?? .pi * 2
    }
    
    var _cornerRadius: ArcFunc1 = { params in
        return params[.cornerRadius] ?? 0
    }
    var _padAngle: ArcFunc1 = { params in
        return params[.padAngle] ?? 0
    }
    var _padRadius: ArcFunc1?
    
    public var centeroid: CGPoint {
        let r = (_innerRadius([:]) + _outerRadius([:])) / 2
        let a = (_startAngle([:]) + _endAngle([:])) / 2
        return CGPoint(x: cos(a) * r, y: sin(a) * r)
    }
    
    public init(_ params: [ArcParameter: ArcFunc1] = [:]){
        for (key: key, value: f) in params {
            switch key {
            case .innerRadius:
                _innerRadius = f
            case .outerRadius:
                _outerRadius = f
            case .startAngle:
                _startAngle = f
            case .endAngle:
                _endAngle = f
            case .cornerRadius:
                _cornerRadius = f
            case .padAngle:
                _padAngle = f
            case .padRadius:
                _padRadius = f
            }
        }
    }
    
    public var context: Path = Path(.zero)
    
    internal func generatePath() -> Path {
        let r0 = min(innerRadius, outerRadius),
        r1 = max(innerRadius, outerRadius),
        a0 = startAngle - .pi * 0.5,
        a1 = endAngle - .pi * 0.5,
        da = abs(a1 - a0),
        cw = a1 > a0
        
        if !(r1 > .epsilon) {
            _ = context.move(to: .zero)
        } else if da > .tau - .epsilon {
            _ = context.move(to: CGPoint(x: r1 * cos(a0),
                                         y: r1 * sin(a0)))
            _ = context.arc(center: .zero, radius: r1, start: a0, end: a1, anticlockwise: !cw)
            if r0 > .epsilon {
//                _ = context.move(to: CGPoint(x:r0 * cos(a1), y:r0 * sin(a1)))
                _ = context.line(to: CGPoint(x:r0 * cos(a1), y:r0 * sin(a1)))
                _ = context.arc(center: .zero, radius: r0, start: a1, end: a0, anticlockwise: cw)
            }
        } else {
            var a00 = a0, a01 = a0,
            a11 = a1, a10 = a1,
            da0 = da, da1 = da,
            ap = padAngle / 2,
            rp = (ap > .epsilon) ? padRadius : 0,
            rc = min(abs(r1 - r0) / 2, cornerRadius),
            rc0 = rc,
            rc1 = rc
            var t0 : (CGFloat, CGFloat, CGFloat, CGFloat, CGFloat, CGFloat),
            t1: (CGFloat, CGFloat, CGFloat, CGFloat, CGFloat, CGFloat)
            
            if rp > .epsilon {
                var p0 = asin(rp / r0 * sin(ap)),
                p1 = asin(rp / r1 * sin(ap))
                
                da0 -= p0 * 2
                if da0 > .epsilon {
                    p0 *= (cw ? 1 : -1)
                    a00 += p0
                    a10 -= p0
                } else {
                    da0 = 0
                    a00 = (a0 + a1) / 2
                    a10 = a00
                }
                
                da1 -= p1 * 2
                if da1 > .epsilon {
                    p1 *= (cw ? 1 : -1)
                    a01 += p1
                    a11 -= p1
                } else {
                    da1 = 0
                    a01 = (a0 + a1) / 2
                    a11 = a01
                }
            }
            let x01 = r1 * cos(a01),
            y01 = r1 * sin(a01),
            x10 = r0 * cos(a10),
            y10 = r0 * sin(a10)
            var x11: CGFloat!, y11: CGFloat!, x00: CGFloat!, y00: CGFloat!,
            ax:CGFloat, ay:CGFloat, bx:CGFloat, by:CGFloat, kc:CGFloat,
            lc:CGFloat

            if (rc > .epsilon) {
                x11 = r1 * cos(a11)
                y11 = r1 * sin(a11)
                x00 = r0 * cos(a00)
                y00 = r0 * sin(a00)
                
                if (da < .pi) {
                    let oc = da0 > .epsilon ? intersect(x01, y01, x00, y00, x11, y11, x10, y10) : CGPoint(x: x10, y: y10)
                    ax = x01 - oc.x
                    ay = y01 - oc.y
                    bx = x11 - oc.x
                    by = y11 - oc.y
                    kc = 1 / sin(acos((ax * bx + ay * by) / (sqrt(ax * ax + ay * ay) * sqrt(bx * bx + by * by))) / 2)
                    lc = sqrt(oc.x * oc.x + oc.y * oc.y)
                    
                    rc0 = min(rc, (r0 - lc) / (kc - 1))
                    rc1 = min(rc, (r1 - lc) / (kc + 1))
                    
                    
                }
            }
            if !(da1 > .epsilon) { _ = context.move(to: CGPoint(x: x01, y: y01)) }
            
            else if rc1 > .epsilon {
                t0 = cornerTangents(x0: x00, y0: y00, x1: x01, y1: y01, r1: r1, rc: rc1, cw: cw)
                t1 = cornerTangents(x0: x11, y0: y11, x1: x10, y1: y10, r1: r1, rc: rc1, cw: cw)
                
                _ = context.move(to :CGPoint(x: t0.0 + t0.2, y: t0.1 + t0.3))
                
                // Have the corners merged?
                if (rc1 < rc) {
                    _ = context.arc(center: CGPoint(x: t0.0, y: t0.1), radius: rc1, start: atan2(t0.3, t0.2), end: atan2(t1.3, t1.2), anticlockwise: !cw)
                }
                
                // Otherwise, draw the two corners and the ring.
                else {
                    _ = context.arc(center: CGPoint(x: t0.0, y: t0.1), radius: rc1, start: atan2(t0.3, t0.2), end: atan2(t0.5, t0.4), anticlockwise: !cw)
                    _ = context.arc(center: .zero, radius: r1, start: atan2(t0.1 + t0.5, t0.0 + t0.4), end: atan2(t1.1 + t1.5, t1.0 + t1.4), anticlockwise: !cw)
                    
                    _ = context.arc(center: CGPoint(x:t1.0, y:t1.1), radius: rc1, start: atan2(t1.5, t1.4), end: atan2(t1.3, t1.2), anticlockwise:!cw)
                }
            }
            else {
                _ = context.move(to: CGPoint(x: x01, y: y01))
                _ = context.arc(center: .zero, radius: r1, start:a01, end:a11, anticlockwise: !cw)
            }
            if !(r0 > .epsilon) || !(da0 > .epsilon) {
                _ = context.line(to: CGPoint(x:x10, y:y10))
            }
            else if rc0 > .epsilon {
                t0 = cornerTangents(x0: x10, y0: y10, x1: x11, y1: y11, r1: r0, rc: -rc0, cw: cw)
                t1 = cornerTangents(x0: x01, y0: y01, x1: x00, y1: y00, r1: r0, rc: -rc0, cw: cw)
                
                _ = context.line(to: CGPoint(x:t0.0 + t0.2, y:t0.1 + t0.3))
                
                // Have the corners merged?
                if (rc0 < rc) {
                    _ = context.arc(center: CGPoint(x: t0.0, y: t0.1), radius: rc0, start:atan2(t0.3, t0.2), end:atan2(t1.3, t1.2), anticlockwise: !cw)
                }
                
                // Otherwise, draw the two corners and the ring.
                else {
                    _ = context.arc(center: CGPoint(x: t0.0, y: t0.1), radius: rc0, start:atan2(t0.3, t0.2), end:atan2(t0.5, t0.4), anticlockwise: !cw)
                    _ = context.arc(center: .zero, radius: r0, start:atan2(t0.1 + t0.5, t0.0 + t0.4), end:atan2(t1.1 + t1.4, t1.0 + t1.5), anticlockwise: cw)
                    _ = context.arc(center: CGPoint(x: t1.0, y: t1.1), radius: rc0, start:atan2(t1.5, t1.4), end:atan2(t1.3, t1.2), anticlockwise: !cw)
                }
            }
            
            // Or is the inner ring just a circular arc?
            else {
                _ = context.arc(center: .zero, radius: r0, start:a10, end:a00, anticlockwise: cw)
            }
        }
        _ = context.closePath()
        let result = context.copy()
        context = Path(.zero)
        return result
    }
    
    public func arc(_ params: ArcParameters = [:]) -> Path {
        for (key: key, value: v) in params {
            switch key {
            case .innerRadius:
                _innerRadius = constant(v)
            case .outerRadius:
                _outerRadius = constant(v)
            case .startAngle:
                _startAngle = constant(v)
            case .endAngle:
                _endAngle = constant(v)
            case .cornerRadius:
                _cornerRadius = constant(v)
            case .padAngle:
                _padAngle = constant(v)
            case .padRadius:
                _padRadius = constant(v)
            }
        }
        return generatePath()
    }
    
    public var innerRadius: CGFloat {
        get {
            return _innerRadius([:])
        }
        set(c) {
            _ = innerRadius(c)
        }
    }
    
    public func innerRadius(_ v: CGFloat) -> Arc {
        _innerRadius = constant(v)
        return self
    }
    
    public func innerRadius(_ f: @escaping ([ArcParameter: CGFloat]) -> CGFloat ) -> Arc {
        _innerRadius = f
        return self
    }
    
    public var outerRadius: CGFloat {
        get {
            return _outerRadius([:])
        }
        set(c) {
            _ = outerRadius(c)
        }
    }
    
    public func outerRadius(_ v: CGFloat) -> Arc {
        _outerRadius = constant(v)
        return self
    }
    
    public func outerRadius(_ f: @escaping ([ArcParameter: CGFloat]) -> CGFloat ) -> Arc {
        _outerRadius = f
        return self
    }
    
    public var startAngle: CGFloat {
        get {
            return _startAngle([:])
        }
        set(c) {
            _ = startAngle(c)
        }
    }
    
    public func startAngle(_ v: CGFloat) -> Arc {
        _startAngle = constant(v)
        return self
    }
    
    public func startAngle(_ f: @escaping ([ArcParameter: CGFloat]) -> CGFloat ) -> Arc {
        _startAngle = f
        return self
    }

    public var endAngle: CGFloat {
        get {
            return _endAngle([:])
        }
        set(c) {
            _ = endAngle(c)
        }
    }
    
    public func endAngle(_ v: CGFloat) -> Arc {
        _endAngle = constant(v)
        return self
    }
    public func endAngle(_ f: @escaping ([ArcParameter: CGFloat]) -> CGFloat ) -> Arc {
        _endAngle = f
        return self
    }
    
    public var padAngle: CGFloat {
        get {
            return _padAngle([:])
        }
        set(c) {
            _ = padAngle(c)
        }
    }
    public func padAngle(_ v: CGFloat) -> Arc {
        _padAngle = constant(v)
        return self
    }
    public func padAngle(_ f: @escaping ([ArcParameter: CGFloat]) -> CGFloat ) -> Arc {
        _padAngle = f
        return self
    }
    
    public var padRadius: CGFloat {
        get {
            return _padRadius?([:]) ?? sqrt(innerRadius * innerRadius + outerRadius * outerRadius)
        }
        set(c) {
            _ = padRadius(c)
        }
    }
    public func padRadius(_ v: CGFloat?) -> Arc {
        if let v = v {
            _padRadius = constant(v)
        } else {
            _padRadius = nil
        }
        return self
    }
    public func padRadius(_ f: (([ArcParameter: CGFloat]) -> CGFloat)? ) -> Arc {
        _padRadius = f
        return self
    }
    
    public var cornerRadius: CGFloat {
        get {
            return _cornerRadius([:])
        }
        set(c) {
            _ = cornerRadius(c)
        }
    }
    public func cornerRadius(_ v: CGFloat) -> Arc {
        _cornerRadius = constant(v)
        return self
    }
    public func cornerRadius(_ f: @escaping ([ArcParameter: CGFloat]) -> CGFloat ) -> Arc {
        _cornerRadius = f
        return self
    }

}
