//
//  Ribbon.swift
//  Hwamei
//
//  Created by ZhangChen on 08/04/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation

public class Ribbon {
    var _radius : Double
    
    public init(radius: Double) {
        _radius = radius
    }
    
    public func ribbon(_ chordPair: Chord.SubgroupPair) -> Path {
        let s = chordPair.source
        let t = chordPair.target
        let sr = s.radius ?? _radius
        let tr = t.radius ?? _radius
        let sa0 = s.startAngle - .pi / 2
        let sa1 = s.endAngle - .pi / 2
        let sx0 = sr * cos(sa0)
        let sy0 = sr * sin(sa0)
        let ta0 = t.startAngle - .pi / 2
        let ta1 = t.endAngle - .pi / 2
        let context = Path(CGMutablePath())
        
        _ = context.move(to: CGPoint(x: sx0, y: sy0))
            .arc(center: .zero, radius: CGFloat(sr), start: CGFloat(sa0), end: CGFloat(sa1))
        if sa0 != ta0 || sa1 != ta1 {
            _ = context.quadraticCurve(with: .zero, to: CGPoint(x:CGFloat(tr * cos(ta0)),
                                                            y:CGFloat(tr * sin(ta0))))
                .arc(center: .zero, radius: CGFloat(tr), start: CGFloat(ta0), end: CGFloat(ta1))
        }
        _ = context.quadraticCurve(with: .zero, to: CGPoint(x: sx0, y: sy0))
            .closePath()
        return context
    }
}
