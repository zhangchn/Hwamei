//
//  Transition.swift
//  Hwamei
//
//  Created by ZhangChen on 03/05/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import QuartzCore

fileprivate func schedule(layer: CALayer,
                          name: String?,
                          id: UUID,
                          index: Int,
                          group: [CALayer],
                          timing: CAAnimation?) {
    
}

fileprivate func defaultTiming() -> CAAnimation {
    let tr = CATransition.init()
    tr.beginTime = CACurrentMediaTime()
    tr.duration = TimeInterval(0.25)
    tr.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    return tr
}

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
        let placeholderLayer = CALayer()
        for inGroup in _groups {
            var subgroupIdx: [Int] = []
            var outSubgroup: [CALayer] = []
            for (idx, node) in inGroup.enumerated() {
                if let subnode = s(node, node.value(forKey:"__data__"), idx, inGroup) {
                    if let d = node.value(forKey: "__data__") {
                        subnode.setValue(d, forKey: "__data__")
                    }
                    outSubgroup.append(subnode)
                    // TODO: schedule(subnode, _name, _id, subgroup, get(node, id))
                    subgroupIdx.append(idx)
                } else {
                    outSubgroup.append(placeholderLayer)
                }
            }
            for idx in subgroupIdx {
                let outNode = outSubgroup[idx]
                schedule(layer: outNode, name: _name, id: _id, index: idx, group: outSubgroup, timing: outNode[_id])
            }
            
            subgroups.append(outSubgroup)
        }
        
        return Transition(groups: subgroups, parents: _parents, name: _name, id: _id)
    }
    
    public override func selectAll(_ s: @escaping SelectorAllFunc) -> Transition {
        var subgroups : [[CALayer]] = []
        var parents : [CALayer] = []
        for group in _groups {
            for (idx, node) in group.enumerated() {
                let children = s(node, node.value(forKey: "__data__"), idx, group)
                
                for (k, child) in children.enumerated() {
                    // TODO: schedule(child, name, id, i, children, timing || inherit(node, id))
                    
                    schedule(layer: child, name: _name, id: _id, index: k, group: children, timing: node[_id]!)
                }
                subgroups.append(children)
                parents.append(node)
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

    fileprivate func inherit(node: CALayer, id: UUID) -> CAAnimation? {
        var currentNode = node
        var timing: CAAnimation? = nil
        repeat {
            guard let tr = currentNode.value(forKey: "__transition__") as? [UUID: CAAnimation], let transition = tr[id] else {
                if let superlayer = currentNode.superlayer {
                    currentNode = superlayer
                } else {
                    return defaultTiming()
                }
                continue
            }
            timing = transition
            break
        } while true
        return timing
    }
    public func transition(_ name: String?, id: UUID = UUID(), useDefaultTiming: Bool = true) -> Transition {
        // TODO: let timing =
        var timing: CAAnimation? = useDefaultTiming ? defaultTiming() : nil
        for group in _groups {
            for (idx, node) in group.enumerated() {
                // TODO: schedule(node, name, id, idx, group, timing ?? inherit(node, id)
                schedule(layer: node, name: name, id: id, index: idx, group: group, timing: timing ?? defaultTiming())
            }
        }
        return Transition(groups: _groups, parents: _parents, name: name, id: id)
    }
    
    public func transition(_ t: Transition) -> Transition {
        return transition(t._name, id: t._id, useDefaultTiming: false)
    }
}

extension CALayer {
    subscript(key: UUID) -> CAAnimation? {
        get {
            let transitions = value(forKey: "__transition__")
            return (transitions as? [UUID: CAAnimation])?[key]
        }
        set {
            if var transitions = value(forKey: "__transition__") as? [UUID: CAAnimation] {
                transitions[key] = newValue
                setValue(transitions, forKey: "__transition__")
            }
        }
    }
}
