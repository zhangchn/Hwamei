//
//  Selection.swift
//  d3s
//
//  Created by ZhangChen on 14/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

//import UIKit
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
