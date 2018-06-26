//
//  Selection.swift
//  Hwamei
//
//  Created by ZhangChen on 14/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import QuartzCore

public class Selection {
    var _parents : [CALayer]
    var _groups : [[CALayer]]
    var _enter : [[EnterNode]]?
    var _exit : [[CALayer]]?
    
    init(_ groups: [[CALayer]], parents: [CALayer], enter: [[EnterNode]]? = nil, exit: [[CALayer]]? = nil) {
        _parents = parents
        _groups = groups
        _enter = enter
        _exit = exit
    }
    /**
     A type of function to be applied over subgroups in Selector
     
     */
    public typealias SelectorFunc = (CALayer, Any?, Int, [CALayer]) -> CALayer?
    /**
     A type of function to be applied over subgroups in SelectorAll
     
     -  A sub-node of CALayer type
     -  Data bound to the parent node
     -  Index of the node being mapped over
     -  The group of sub-nodes being mapped over
     */
    public typealias SelectorAllFunc = (CALayer, Any?, Int, [CALayer]) -> [CALayer]
    
    public func select(_ s: NSPredicate?) -> Selection {
        let s1: SelectorFunc = selector(s)
        return select(s1)
    }
    
    public func select(_ s: SelectorFunc) -> Selection {
        let subgroups : [[CALayer]] = _groups.map { group -> [CALayer] in
            let subgroup : [CALayer] = group.enumerated().compactMap({ (p: (index: Int, node: CALayer)) -> CALayer? in
                let subnode = s(p.node, p.node.value(forKey: "__data__"), p.index, group)
                if let nodeData = p.node.value(forKey: "__data__") {
                    subnode?.setValue(nodeData, forKey: "__data__")
                }
                return subnode
            })
            return subgroup
        }
        return Selection(subgroups , parents: _parents)
    }
    
    
    /**
     Select all CALayer sub-nodes in a selection, filtering with a predicate object.
     
     - parameter p: a predicate object.
     - returns: See `selectAll(_ s: @escaping SelectorAllFunc) -> Selection`
     */
    public func selectAll(_ p: NSPredicate?) -> Selection {
        return selectAll(selectorAll(p))
    }
    /**
     Select all CALayer sub-nodes in a selection, filtering with a predicate.
     
     - parameter s:  a predicate function, see `SelectorAllFunc`
     
     - returns: a Selection object containing selected sub-nodes.
     The dimension of returned groups = (#-of-groups * #-of-node-in-group , #-of-matches-in-node)
     */
    public func selectAll(_ s: @escaping SelectorAllFunc) -> Selection {
        var subgroups : [[CALayer]] = []
        var parents : [CALayer] = []
        for group in _groups {
            for (idx, node) in group.enumerated() {
                subgroups.append(s(node, node.value(forKey: "__data__"), idx, group))
                parents.append(node)
            }
        }
        return Selection(subgroups, parents: parents)
    }

}

func selector(_ s: NSPredicate?) -> EnterSelection.SelectorFunc {
    if let s = s {
        return { node, _, _, _ in
            return node._parent?.querySelector(s)
        }
    } else {
        return { _, _, _, _ in return nil }
    }
}


func selector(_ s: NSPredicate?) -> Selection.SelectorFunc {
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
