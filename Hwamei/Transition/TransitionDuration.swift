//
//  TransitionDuration.swift
//  Hwamei
//
//  Created by ZhangChen on 2019/7/21.
//  Copyright © 2019 Zhang Chen. All rights reserved.
//

import Foundation

extension Transition {
    var duration: CFTimeInterval? {
        get {
            return node()?[_id]?.duration
        }
        set {
            if let tr = node()?[_id] {
                tr.duration = newValue!
            }
        }
    }
    
    func duration(_ valueFunc: (CALayer, Any?, Int, [CALayer]) -> CFTimeInterval ) -> Transition {
        return each() { (a, b, c, d) in
            node()![_id]!.duration = valueFunc(a, b, c, d)
        } as! Transition
    }
    
    func duration(_ value: CFTimeInterval) -> Transition {
        return each() { (a, b, c, d) in
            node()![_id]!.duration = value
        } as! Transition
    }
}
