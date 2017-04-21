//
//  Property.swift
//  Hwamei
//
//  Created by ZhangChen on 19/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation
import QuartzCore

extension Selection {
    public func property(_ name: String) -> Any? {
        return node()?.value(forKey: name)
    }
    
    public func property(_ name: String, value: Any?) -> Selection {
        return each({ (node, _, _, _) in
            node.setValue(value, forKey: name)
        })
    }
    
    public func property(_ name: String, _ functional: (CALayer, Any?, Int, [CALayer]) -> Any?) -> Selection {
        return each({ (node, datum, idx, group) in
            node.setValue(functional(node, datum, idx, group), forKey: name)
        })
    }
    /*
    public func position(_ point: (CALayer, Any?, Int, [CALayer]) -> CGPoint?) -> Selection {
        return each({ (node, datum, idx, group) in
            if let p = point(node, datum, idx, group) {
                node.position = p
            }
        })
    }
    
    public func position(_ point: [CGPoint]) -> Selection {
        return position({ (_, _, idx, _) -> CGPoint? in
            return point[idx]
        })
    }
    
    public func position(_ point: CGPoint) -> Selection {
        return each({ (node, _, _, _) in node.position = point})
    }
     */
}
