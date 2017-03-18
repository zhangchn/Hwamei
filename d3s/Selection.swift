//
//  Selection.swift
//  d3s
//
//  Created by ZhangChen on 14/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import UIKit
import QuartzCore

enum TransitionNode {
    case enter(EnterNode)
    case update(CALayer)
    case exit(CALayer)
}

enum KeyArgument {
    case group([CALayer])
    case data([Any])
}

class Selection {
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

protocol SelectionData {
    // KeyFunc is type for a function which would be called in two ways, passing arguments of: 1) a node, the corresponding data for this node, its index and the group of the node where the node is an element of the group being tranversed; and 2) the parent node of the group, a datum, its index, and the new data of the group, where the datum is an element of new data of the group.
    typealias KeyFunc = (CALayer, Any?, Int, KeyArgument) -> String
    typealias ValueFunc = (CALayer, Any?, Int, [CALayer]) -> [Any]
    func data(value: ValueFunc, key: KeyFunc?) -> Selection
    func data(value: [[Any?]], key: KeyFunc?) -> Selection
    var data: [Any] { get }
}


func bind(_ parent: CALayer, group: [CALayer], data: [Any], keyFunc: SelectionData.KeyFunc? = nil) -> [TransitionNode] {
    guard keyFunc != nil else {
        return bindIndex(parent, group: group, data: data)
    }
//    var update : [CALayer] = []
//    var enter: [EnterNode] = []
//    var exit : [CALayer] = []
    var transitionNodes : [TransitionNode] = []

    var keyValues : [String] = []
    var duplicated: [TransitionNode] = []
    var nodeByKeyValue : [String: CALayer] = [:]
    
    for (idx, node) in group.enumerated() {
        let key = keyFunc!(node, node.value(forKey: "__data__"), idx, .group(group))
        keyValues.append(key)
        if nodeByKeyValue[key] != nil {
            //mark nodes with duplicated keys as exit
            duplicated.append(.exit(node))
        } else {
            nodeByKeyValue[key] = node
        }
    }
    for (idx, datum) in data.enumerated() {
        let key = keyFunc!(parent, datum, idx, .data(data))
        if let node = nodeByKeyValue[key] {
            transitionNodes.append(.update(node))
            node.setValue(datum, forKey: "__data__")
            nodeByKeyValue.removeValue(forKey: key)
        } else {
            transitionNodes.append(.enter(EnterNode(parent, datum: datum)))
        }
    }
    for (idx, node) in group.enumerated() {
        if nodeByKeyValue[keyValues[idx]] === node {
            transitionNodes.append(.exit(node))
        }
    }
    
    transitionNodes.append(contentsOf: duplicated)
    
    return transitionNodes
}

func bindIndex(_ parent: CALayer, group: [CALayer], data: [Any]) -> [TransitionNode] {
    
    var transitionNodes : [TransitionNode] = []

    for i in 0..<min(group.count, data.count) {
        group[i].setValue(data[i], forKey: "__data__")
        //update.append(group[i])
        transitionNodes.append(.update(group[i]))
    }
    if group.count < data.count {
        for i in group.count..<data.count {
            transitionNodes.append(.enter(EnterNode(parent, datum: data[i])))
        }
    }
    if group.count > data.count {
        for i in data.count ..< group.count {
            transitionNodes.append(.exit(group[i]))
        }
    }
    return transitionNodes
}

extension Selection: SelectionData {
    
    var data: [Any] {
        get {
            let d: [Any] = []
            // TODO: each data
            return d
        }
    }
    
    func data(value: SelectionData.ValueFunc, key: SelectionData.KeyFunc? = nil) -> Selection {
        var updateGroups : [[CALayer]] = []
        var enterGroups : [[EnterNode]] = []
        var exitGroups : [[CALayer]] = []
        for (idx, group) in _groups.enumerated() {
            let parent = _parents[idx]
            let data = value(parent, parent.value(forKey: "__data__"), idx, _parents)
            var transitionNodes = bind(parent, group: group, data: data, keyFunc: key)
            
            var i1 = 0
            for i0 in 0..<data.count {

                switch transitionNodes[i0] {
                case .enter(let p):
                    i1 = max(i0 + 1, i1)
                    var next : CALayer? = nil
                    while i1 < data.count {
                        switch transitionNodes[i1] {
                        case .update(let n):
                            next = n
                        default:
                            i1 += 1
                            continue
                        }
                        break
                    }
                    p._next = next
                    transitionNodes[i0] = .enter(p)
                default:
                    break
                }
            }
            var enterGroup : [EnterNode] = []
            var exitGroup : [CALayer] = []
            var updateGroup : [CALayer] = []
            for node in transitionNodes {
                switch node {
                case .enter(let e):
                    enterGroup.append(e)
                case .exit(let e):
                    exitGroup.append(e)
                case .update(let u):
                    updateGroup.append(u)
                }
            }
            
            updateGroups.append(updateGroup)
            enterGroups.append(enterGroup)
            exitGroups.append(exitGroup)
        }
        let update = Selection(updateGroups, parents: _parents, enter: enterGroups, exit: exitGroups)
        return update
    }
    
    func data(value: [[Any?]], key: SelectionData.KeyFunc? = nil) -> Selection {
        let valueFunc: SelectionData.ValueFunc = { _, _, _, _ in
            return value
        }
        return data(value: valueFunc, key: key)
    }
    
}
