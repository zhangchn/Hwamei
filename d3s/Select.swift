//
//  Select.swift
//  d3s
//
//  Created by ZhangChen on 15/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import QuartzCore

public protocol SelectionSelect {
    func select(_ s: NSPredicate?) -> Selection
    //func select(_ s: (CALayer, Any?, Int, [CALayer]) -> CALayer?) -> Selection
}

extension Selection: SelectionSelect {
    public typealias SelectorFunc = (CALayer, Any?, Int, [CALayer]) -> CALayer?
    public func select(_ s: NSPredicate?) -> Selection {
        let s1 = selector(s)
        return select(s1)
    }
    
    public func select(_ s: SelectorFunc) -> Selection {
        let subgroups : [[CALayer]] = _groups.map { group -> [CALayer] in
            let subgroup : [CALayer] = group.enumerated().flatMap({ (p: (index: Int, node: CALayer)) -> CALayer? in
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
}

