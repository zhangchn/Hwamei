//
//  SelectAll.swift
//  d3s
//
//  Created by ZhangChen on 15/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import QuartzCore

protocol SelectionSelectAll {
    func selectAll(_ p: NSPredicate?) -> Selection
    //func selectAll(_ s: @escaping (CALayer, Any?, Int, [CALayer]) -> [CALayer]) -> Selection
}

extension Selection : SelectionSelectAll {
    
    typealias SelectorAllFunc = (CALayer, Any?, Int, [CALayer]) -> [CALayer]
    func selectAll(_ p: NSPredicate?) -> Selection {
        return selectAll(selectorAll(p))
    }
    
    func selectAll(_ s: @escaping SelectorAllFunc) -> Selection {
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
