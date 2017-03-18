//
//  Property.swift
//  d3s
//
//  Created by ZhangChen on 19/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation

extension Selection {
    func property(_ name: String) -> Any? {
        return node()?.value(forKey: name)
    }
    
    func property(_ name: String, value: Any?) -> Selection {
        return each(callback: { (node, _, _, _) in
            node.setValue(value, forKey: name)
        })
    }
    
    func property(_ name: String, value: (CALayer, Any?, Int, [CALayer]) -> Any?) -> Selection {
        return each(callback: { (node, datum, idx, group) in
            node.setValue(value(node, datum, idx, group), forKey: name)
        })
    }
}
