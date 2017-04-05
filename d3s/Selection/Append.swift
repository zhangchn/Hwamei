//
//  Create.swift
//  d3s
//
//  Created by ZhangChen on 15/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import QuartzCore


public enum CreatorType {
    case shape, tile, text, gradient, layer
}

extension Selection {
    class func creator(name: CreatorType) -> Selection.SelectorFunc {
        return { (_, _, _, _) -> CALayer? in
            switch name {
            case .shape:
                return CAShapeLayer()
            case .gradient:
                return CAGradientLayer()
            case .text:
                return CATextLayer()
            case .tile:
                return CATiledLayer()
            case .layer:
                return CALayer()
            }
        }
    }

    public func append(name: SelectorFunc ) -> Selection {
        return select() { (node, data, index, group) -> CALayer? in
            if let layer = name(node, data, index, group) {
                layer.contentsScale = UIScreen.main.scale
                layer.masksToBounds = false
                if layer.style == nil {
                    layer.style = [:]
                }
                node.addSublayer(layer)
                return layer
            }
            return nil
        }
    }
    
    public func append(name: CreatorType) -> Selection {
        let create = type(of: self).creator(name: name)
        return append(name: create)
    }
}

extension EnterSelection {
    public typealias SelectorFunc = (EnterNode, Any?, Int, [EnterNode]) -> CALayer?

    public func select(_ s: @escaping SelectorFunc) -> Selection {
        let subgroups : [[CALayer]] = _enterGroups.map { group -> [CALayer] in
            let subgroup : [CALayer] = group.enumerated().flatMap({ (p: (index: Int, node: EnterNode)) -> CALayer? in
                let subnode = s(p.node, p.node._data, p.index, group)
                if let nodeData = p.node._data {
                    subnode?.setValue(nodeData, forKey: "__data__")
                }
                return subnode
            })
            return subgroup
        }
        return Selection(subgroups , parents: _parents)
    }

    public func append(name: @escaping SelectorFunc) -> Selection {
        return select() { (node, data, index, group) -> CALayer? in
            if let layer = name(node, data, index, group) {
                layer.contentsScale = UIScreen.main.scale
                layer.masksToBounds = false
                if layer.style == nil {
                    layer.style = [:]
                }
                if let next = node._next {
                    node._parent?.insertSublayer(layer, below: next)
                } else {
                    node._parent?.addSublayer(layer)
                }
                return layer
            }
            return nil
        }
    }
    
    internal class func creator(name: CreatorType) -> SelectorFunc {
        return { (_, _, _, _) -> CALayer? in
            switch name {
            case .shape:
                return CAShapeLayer()
            case .gradient:
                return CAGradientLayer()
            case .text:
                return CATextLayer()
            case .tile:
                return CATiledLayer()
            case .layer:
                return CALayer()
            }
        }
    }

    public func append(name: CreatorType) -> Selection {
        let create =  type(of: self).creator(name: name)
        return append(name: create)
    }
}
