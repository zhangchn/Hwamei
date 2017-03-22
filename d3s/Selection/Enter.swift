//
//  Enter.swift
//  d3s
//
//  Created by ZhangChen on 16/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import QuartzCore

public class EnterNode {
    var _data: Any?
    weak var _parent: CALayer?
    weak var _next: CALayer?
    init(_ parent: CALayer?, datum: Any?) {
        _parent = parent
        _data = datum
    }
    
    func append(child: CALayer) {
        _parent?.insertSublayer(child, below: _next)
    }
    
    func insert(child: CALayer, before next: CALayer?) {
        _parent?.insertSublayer(child, below: next)
    }
    
    func query(selector: NSPredicate) -> CALayer? {
        return _parent?.querySelector(selector)
    }
    
    func queryAll(selector: NSPredicate) -> [CALayer] {
        return _parent?.querySelectorAll(selector) ?? []
    }
}

public class EnterSelection {
    var _enterGroups : [[EnterNode]]
    var _parents: [CALayer]
    init(_ groups: [[EnterNode]] , parents: [CALayer]) {
        _parents = parents
        _enterGroups = groups
    }
}

extension Selection {
    public func enter() -> EnterSelection {
        let enter = _enter ?? [[EnterNode]](repeating: [], count: _groups.count)
        return EnterSelection(enter , parents: _parents)
    }
}
