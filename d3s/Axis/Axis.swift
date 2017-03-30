//
//  Axis.swift
//  d3s
//
//  Created by ZhangChen on 30/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import QuartzCore

enum AxisOrientation {
    case top
    case bottom
    case left
    case right
    var isHorizontal : Bool { return self == .top || self == .bottom }
    var isVertical : Bool { return self == .left || self == .right }
    var coordinate: Coordinate {
        return isHorizontal ? .x : .y
    }
}

func translate(x: CGFloat) -> CATransform3D {
    return CATransform3DMakeScale(x, 0, 0)
}

func translate(y: CGFloat) -> CATransform3D {
    return CATransform3DMakeScale(0, y, 0)
}
enum Coordinate {
    case x
    case y
    var tangent1 : String {
        switch self {
        case .x:
            return "x1"
        case .y:
            return "y1"
        }
    }
    var tangent2 : String {
        switch self {
        case .x:
            return "x2"
        case .y:
            return "y2"
        }
    }
    var normal1 : String {
        switch self {
        case .x:
            return "y1"
        case .y:
            return "x1"
        }
    }
    var normal2 : String {
        switch self {
        case .x:
            return "y2"
        case .y:
            return "x2"
        }
    }
}


class Axis<D, R, S: Scale> where S.DomainType == D, S.RangeType == R {
    
    var _scale: S
    var _orient: AxisOrientation
    var _tickArguments: [String: Any] = [:]
    var _tickValues: [S.DomainType]?
    var _tickFormat: FormatFunc? = nil
    var _tickSizeInner: CGFloat = 6
    var _tickSizeOuter: CGFloat = 6
    var _tickPadding: CGFloat = 3
    var _transform: (CGFloat) -> CATransform3D
    var _k : CGFloat
    init(orientation: AxisOrientation, scale: S) {
        _orient = orientation
        _scale = scale
        _transform = orientation.isHorizontal ? translate(x:) : translate(y:)
        _k = orientation == .top || orientation == .left ? -1 : 1
    }
    
    func axis(_ context: Selection) {
        let tvs = _tickValues ?? (_scale.ticks?(_tickArguments) ?? _scale.domain)
    }
}
