//
//  Transition.swift
//  Hwamei
//
//  Created by ZhangChen on 03/05/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import QuartzCore

public class Transition: Selection {
    var _name: String?
    var _id: UUID
    init(groups: [[CALayer]], parents: [CALayer], name: String?, id: UUID) {
        _name = name
        _id = id
        super.init(groups, parents: parents)
        doSchedule()
    }
    
    public override func select(_ s: Selection.SelectorFunc) -> Transition {
        var subgroups : [[CALayer]] = []
        for group in _groups {
            var subgroup: [CALayer] = []
            for (idx, node) in group.enumerated() {
                if let subnode = s(node, node.value(forKey:"__data__"), idx, group) {
                    if let d = node.value(forKey: "__data__") {
                        subnode.setValue(d, forKey: "__data__")
                    }
                    subgroup.append(subnode)
                    // TODO: schedule(subnode, _name, _id, subgroup, get(node, id))
                }
            }
            subgroups.append(subgroup)
        }
        
        return Transition(groups: subgroups, parents: _parents, name: _name, id: _id)
    }
    
    public override func selectAll(_ s: @escaping SelectorAllFunc) -> Transition {
        var subgroups : [[CALayer]] = []
        var parents : [CALayer] = []
        for group in _groups {
            for (idx, node) in group.enumerated() {
                let children = s(node, node.value(forKey: "__data__"), idx, group)
                subgroups.append(children)
                parents.append(node)
                for (i, child) in children.enumerated() {
                    // TODO: schedule(child, name, id, i, children, inherit)
                }
            }
        }
        return Transition(groups: subgroups, parents: parents, name: _name, id: _id)
    }
    
    public func selection() -> Selection {
        return Selection(_groups, parents: _parents)
    }
    
    func doSchedule() {
        DispatchQueue.main.async {
            for children in self._groups {
                for (i, child) in children.enumerated() {
                    // Collect each and every transactions to be commited;
                    // Pop up to nodes up in the view hierarchy;
                    // Combine these transactions into a tree of CATransactions;
                    // Commit a CATransaction, iff all its subtransactions are combined.
                }
            }
        }
    }
}

extension Selection {

    public func transition(_ name: String?, id: UUID = UUID()) -> Transition {
        // TODO: let timing =
        for group in _groups {
            for (idx, node) in group.enumerated() {
                // TODO: schedule(node, name, id, idx, group, timing ?? inherit(node, id)
                
            }
        }
        
        return Transition(groups: _groups, parents: _parents, name: name, id: id)
    }
    
    public func transition(_ t: Transition) -> Transition {
        return transition(t._name, id: t._id)
    }
}
