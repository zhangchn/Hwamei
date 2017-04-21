//
//  SelectAll.swift
//  Hwamei
//
//  Created by ZhangChen on 15/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import QuartzCore

extension Selection {
    /**
     A type of function to be mapped over subgroups in SelectorAll
    
     -  A sub-node of CALayer type
     -  Data bound to the parent node
     -  Index of the node being mapped over
     -  The group of sub-nodes being mapped over
     */
    public typealias SelectorAllFunc = (CALayer, Any?, Int, [CALayer]) -> [CALayer]
    
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
