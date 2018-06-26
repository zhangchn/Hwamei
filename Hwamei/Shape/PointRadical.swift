//
//  PointRadical.swift
//  Hwamei
//
//  Created by ZhangChen on 19/06/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation

public func pointRadical(_ point: CGPoint) -> CGPoint {
    let a = point.x - .pi / 2
    let r = point.y
    return CGPoint(x: r * cos(a) , y: r * sin(a))
}
