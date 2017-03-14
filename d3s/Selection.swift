//
//  Selection.swift
//  d3s
//
//  Created by ZhangChen on 14/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import UIKit
import QuartzCore

extension CALayer {
    func querySelector(_ p: NSPredicate) -> CALayer? {
        if let sublayers = sublayers {
            for l in sublayers {
                if p.evaluate(with: l) {
                    return l
                }
            }
        }
        return nil
    }
    
    func querySelectorAll(_ p: NSPredicate) -> [CALayer] {
        if let sublayers = sublayers {
            return sublayers.filter { p.evaluate(with: $0) }
        }
        return []
    }
}

class Selection {
    var parents : [CALayer]
    var groups : [[CALayer]]
    init(_ groups: [[CALayer]], parents: [CALayer]) {
        self.parents = parents
        self.groups = groups
    }
    func select(_ s: NSPredicate?) -> Selection {
        let s1 = selector(s)
        return select(s1)
    }
    
    func select(_ s: (CALayer, Any?, Int, [CALayer]) -> CALayer?) -> Selection {
        let subgroups : [[CALayer]] = groups.map { group -> [CALayer] in
            let subgroup : [CALayer] = group.enumerated().flatMap({ (p: (index: Int, node: CALayer)) -> CALayer? in
                let subnode = s(p.node, p.node.value(forKey: "__data__"), p.index, group)
                if let nodeData = p.node.value(forKey: "__data__") {
                    subnode?.setValue(nodeData, forKey: "__data__")
                }
                return subnode
            })
            return subgroup
        }
        return Selection(subgroups , parents: self.parents)
    }
    
    func selectAll(_ p: NSPredicate?) -> Selection {
        return selectAll(selectorAll(p))
    }
    
    func selectAll(_ s: @escaping (CALayer, Any?, Int, [CALayer]) -> [CALayer]) -> Selection {
        var subgroups : [[CALayer]] = []
        var parents : [CALayer] = []
        for group in groups {
            for (idx, node) in group.enumerated() {
                subgroups.append(s(node, node.value(forKey: "__data__"), idx, group))
                parents.append(node)
            }
        }
    
        return Selection(subgroups, parents: parents)
    }
}

func selector(_ s: NSPredicate?) -> (CALayer, Any?, Int, [CALayer]) -> CALayer? {
    if let s = s {
        return { node, _, _, _ in return node.querySelector(s)}
    } else {
        return { _, _, _, _ in return nil }
    }
}

func selectorAll(_ s: NSPredicate?) -> (CALayer, Any?, Int, [CALayer]) -> [CALayer] {
    if let s = s {
        return { node, _, _, _ in return node.querySelectorAll(s)}
    } else {
        return { _, _, _, _ in return []}
    }
}

extension UIView {
    
    func selectAll(_ p: NSPredicate) -> Selection {
        return Selection([self.layer.querySelectorAll(p)], parents: [self.layer])
    }
    
    
}

