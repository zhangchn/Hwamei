//
//  Create.swift
//  d3s
//
//  Created by ZhangChen on 15/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import QuartzCore


enum CreatorClass {
    case shape, tile, text, gradient, layer
}
func creator(name: CreatorClass) -> Selection.SelectorFunc {
    return { (node, _, _, _) -> CALayer? in
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

extension Selection {
    func append(name: SelectorFunc ) -> Selection {
        return select() { (node, data, index, group) -> CALayer? in
            if let layer = name(node, data, index, group) {
                node.addSublayer(layer)
                return layer
            }
            return nil
        }
    }
    
    func append(name: CreatorClass) -> Selection {
        let create = creator(name: name)
        return append(name: create)
    }
}
