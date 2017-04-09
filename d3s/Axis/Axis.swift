//
//  Axis.swift
//  d3s
//
//  Created by ZhangChen on 30/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import QuartzCore
import CoreGraphics

public enum AxisOrientation {
    case top
    case bottom
    case left
    case right
    var isHorizontal : Bool { return self == .top || self == .bottom }
    var isVertical : Bool { return self == .left || self == .right }
}

func translate(x: CGFloat) -> CATransform3D {
    return CATransform3DMakeScale(x, 0, 0)
}

func translate(y: CGFloat) -> CATransform3D {
    return CATransform3DMakeScale(0, y, 0)
}

public class Axis<D, S: RangedScale> where S.DomainType == D, S.RangeType == CGFloat {
    
    var _scale: S
    public var scale: S {
        get {
            return _scale
        }
    }
    
    public func scale(_ s : S) -> Self {
        _scale = s
        return self
    }
    
    var _orient: AxisOrientation
    public var orient: AxisOrientation {
        set {
            _orient = newValue
        }
        get {
            return _orient
        }
    }
    
    public func orient(_ o: AxisOrientation) -> Self {
        _orient = o
        return self
    }
    
    var _tickArguments: [String: Any] = [:]
    
    public var tickArguments: [String: Any] {
        get { return _tickArguments }
        set { _tickArguments = newValue }
    }
    public func tickArguments(_ ta: [String: Any]) -> Self {
        _tickArguments = ta
        return self
    }
    var _tickValues: [D]?
    public var tickValues: [D]? {
        get { return _tickValues }
        set { _tickValues = newValue }
    }
    public func tickValues(_ tv: [D]?) -> Self {
        _tickValues = tv
        return self
    }
    
    var _tickFormat: FormatFunc? = nil
    public var tickFormat: FormatFunc? {
        get { return _tickFormat }
        set { _tickFormat = newValue }
    }
    public func tickFormat(_ tf: FormatFunc?) -> Self {
        _tickFormat = tf
        return self
    }
    
    var _tickSizeInner: CGFloat = 6
    public var tickSize: CGFloat {
        get { return _tickSizeInner }
        set { _tickSizeInner = newValue
            _tickSizeOuter = newValue }
    }
    public func tickSize(_ ts: CGFloat) -> Self {
        _tickSizeInner = ts
        _tickSizeOuter = ts
        return self
    }

    public var tickSizeInner: CGFloat {
        get { return _tickSizeInner }
        set { _tickSizeInner = newValue }
    }
    public func tickSizeInner (_ ts: CGFloat) -> Self {
        _tickSizeInner = ts
        return self
    }

    var _tickSizeOuter: CGFloat = 6
    public var tickSizeOuter: CGFloat {
        get { return _tickSizeOuter }
        set { _tickSizeOuter = newValue }
    }
    public func tickSizeOuter (_ ts: CGFloat) -> Self {
        _tickSizeOuter = ts
        return self
    }
    var _tickPadding: CGFloat = 3
    public var tickSizePadding: CGFloat {
        get { return _tickPadding }
        set { _tickPadding = newValue }
    }

    public func tickPadding(_ tp: CGFloat) -> Self {
        _tickPadding = tp
        return self
    }
    
    var _transform: (CGFloat) -> CATransform3D
    var _k : CGFloat
    public init(orientation: AxisOrientation, scale: S) {
        _orient = orientation
        _scale = scale
        _transform = orientation.isHorizontal ? translate(x:) : translate(y:)
        _k = orientation == .top || orientation == .left ? -1 : 1
        
        _tickArguments = ["count": _scale.domain.count, "specifier": ""]
    }
    
    public func axis(_ context: Selection) {
        // tick values
        let tvs: [D] = _tickValues ?? (_scale.ticks?(_tickArguments) ?? _scale.domain)
        let tf = _tickFormat ?? (_scale.tickFormat?(_tickArguments["count"] as! Int,
                                                    _tickArguments["specifier"] as! String) ?? { x in x.description } )
        let spacing = max(_tickSizeInner, 0) + _tickPadding
        let range = _scale.range
        let range0 = range.first! + 0.5
        let range1 = range.last! + 0.5
        // TODO: center for band scale
        let position = _scale.scale
        //        let selection = context
        let path0 = context.selectAll(NSPredicate(format: "cls = 'domain'")).data([[]])
        
        let tickKeyFunc: SelectionData.KeyFunc = { (layer, datum, idx, keyArg) -> String in
            return "\(self._scale.scale(datum as! D))"
        }
        let defaultColorComponents : [CGFloat] = [0, 0, 0, 1]
        let defaultColor = CGColor.init(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)! , components: defaultColorComponents)
        
        let tickPred = NSPredicate(format: "cls = 'tick'")
        let tick0: Selection = context.selectAll(tickPred).data(tvs, key: tickKeyFunc)
        let tickExit = tick0.exit()
        let tickEnter = tick0.enter()
            .append(name: .layer)
            .property("cls", value: "tick")
        let line0 = tick0.select(NSPredicate(format: "cls = 'line'"))
        let text0 = tick0.select(NSPredicate(format: "cls = 'text'"))
        
        _ = tickExit.remove()
        
        let path1 = path0.merge(path0.enter()
            .insert(name: .shape, before: tickPred)
            .property("cls", value: "domain")
            .property("lineWidth", value: 1.0)
            .property("fillColor", value: nil)
            .style(name: "strokeColor", value: defaultColor))
        
        
        let tick1 = tick0.merge(tickEnter)
        let line1Path = Path()
            .move(to: _orient.isVertical ? CGPoint(x: 0, y: 0.5): CGPoint(x: 0.5, y: 0))
            .line(to: _orient.isVertical ? CGPoint(x: _k * _tickSizeInner, y: 0.5): CGPoint(x: 0.5, y: _k * _tickSizeInner))
        
        
        _ = line0.merge(tickEnter.append(name: .shape)
            .property("cls", value: "line")
            .property("strokeColor", value: defaultColor)
            .property("lineWidth", value: 1.0)
            .property("path", value: line1Path.path))
        
        let text1 = text0.merge(tickEnter.append(name: .text)
            .property("cls", value: "text")
            .property("fontSize", value: 10)
            .property("truncationMode", value: kCATruncationNone)
            .property("frame", value: CGRect(x: 0, y: 0, width: spacing * 2.0, height: 15))
            .property("foregroundColor", value: defaultColor)
            .property("position", value: _orient.isVertical ? CGPoint(x: _k * spacing * 1.5, y: 0.5) : CGPoint(x:0.5, y: _k * spacing))
        )
        // TODO: transition
        
        _ = tickExit.remove()
        
        let path1Path = Path()
        _ = path1Path.move(to: _orient.isVertical
            ?
                CGPoint(x: _k * _tickSizeOuter, y: CGFloat(range0))
            :
            CGPoint(x: CGFloat(range0), y: _k * _tickSizeOuter))
        .line(to: _orient.isVertical
            ?
                CGPoint(x: 0.5, y: CGFloat(range0))
            :
            CGPoint(x: CGFloat(range0), y: 0.5))
        .line(to: _orient.isVertical ? CGPoint(x: 0.5, y: range1) : CGPoint(x: range1, y: 0.5))
        .line(to: _orient.isVertical
            ?
                CGPoint(x: _k * _tickSizeOuter, y: CGFloat(range1))
            :
            CGPoint(x: CGFloat(range1), y: _k * _tickSizeOuter))
        _ = path1.property("path", value: path1Path.path)
        
        _ = tick1.property("alpha", value: CGFloat(1.0))
            .property("position") { (_, datum, _, _) in
                CGPoint(x: 0, y:(CGFloat(position(datum as! D))))
        }
        
        
        _ = text1.property("string") {(layer, datum, _, _) in
            if let d = datum as? Double {
                return tf(d)
            } else if let d = datum as? String {
                return tf(d)
            } else {
                return "x"
            }
        }
        
        _ = context.filter({ layer, _, _, _ in layer.value(forKey: "__axis") == nil})
            .property("fillColor", value: nil)
            .property("anchorPoint") { layer, _, _, _ in
                if layer is CATextLayer {
                    switch _orient {
                    case .left:
                        return CGPoint(x: 1, y: 0.5)
                    case .right:
                        return CGPoint(x: 0.5, y: 1)
                    default:
                        return CGPoint(x: 0.5, y: 1.0)
                    }
                } else {
                    return CGPoint(x: 0, y: 0)
                }
        }
        
        _ = context.each({ (layer, datum, index, group) in
            layer.setValue(position, forKey: "__axis")
        })
    }
}
