//
//  HexBin.swift
//  Hwamei
//
//  Created by ZhangChen on 20/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation
import CoreGraphics

fileprivate let angels = [0,
                          CGFloat.pi / 3.0,
                          2.0 * CGFloat.pi / 3.0,
                          CGFloat.pi,
                          4.0 * CGFloat.pi / 3.0,
                          5.0 * CGFloat.pi / 3.0]

public class HexBin {
    public typealias Bin = (center: CGPoint, points: [CGPoint])
    var _radius : CGFloat
    var _dx: CGFloat
    var _dy: CGFloat
    var x0 = 0, y0 = 0, x1 = 1, y1 = 1
    public init(radius: CGFloat = 1.0) {
        _radius = radius
        _dx = radius * 2.0 * sin(CGFloat.pi / 3.0)
        _dy = radius * 1.5
    }
    
    var x: (CGPoint) -> CGFloat = { $0.x }
    var y: (CGPoint) -> CGFloat = { $0.y }
    
    public func hexagon(radius: CGFloat? = nil) -> CGPath {
        let r = radius ?? _radius
        let points: [CGPoint] = angels.map {
            CGPoint(x: sin($0) * r, y: cos($0) * r)
        }
        let path = CGMutablePath()
        path.move(to: points.last!)
        for i in 0..<5 {
            path.addLine(to: points[i])
        }
        path.closeSubpath()
        return path
    }
    
    public func hexbin(_ points: [CGPoint]) -> [Bin] {
        var binsById : [AnyHashable: Bin] = [:]
        var bins :[Bin] = []
        for point in points {
            guard !x(point).isNaN && !y(point).isNaN else {
                continue
            }
            var py = y(point) / _dy,
            pj = round(py),
            px = x(point) / _dx - CGFloat(Int(pj) & 1) / 2.0,
            pi = round(px),
            py1 = py - pj
            
            if abs(py1) * 3.0 > 1.0 {
                let px1 = px - pi,
                pi2 = pi + (px < pi ? -0.5 : 0.5),
                pj2 = pj + (py < pj ? -1.0 : 1.0),
                px2 = px - pi2,
                py2 = py - pj2
                
                if px1 * px1 + py1 * py1 > px2 * px2 + py2 * py2 {
                    pi = pi2 + (Int(pj) & 1 != 0 ? 0.5 : -0.5)
                    pj = pj2
                }
                
            }
            let id = String(format: "%f-%f", pi, pj)
            if binsById[id] != nil {
                binsById[id]!.points.append(point)
            } else {
                binsById[id] = Bin(center: CGPoint(x: (pi + CGFloat(Int(pj) & 1) * 0.5) * _dx,
                                                 y: pj * _dy),
                                   points: [point])
            }
        }
       
        for (_, bin) in binsById {
            bins.append(bin)
        }
        return bins
    }
    
    public func x(_ newFunc: @escaping (CGPoint) -> CGFloat ) -> Self {
        self.x = newFunc
        return self
    }
    
    public func y(_ newFunc: @escaping (CGPoint) -> CGFloat ) -> Self {
        self.y = newFunc
        return self
    }

}
