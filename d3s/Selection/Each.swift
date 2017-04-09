//
//  Each.swift
//  d3s
//
//  Created by ZhangChen on 19/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation
import QuartzCore

extension Selection {
    public func each (_ callback: (CALayer, Any?, Int, [CALayer]) -> () ) -> Selection {
        for group in _groups {
            for (idx, node) in group.enumerated() {
                callback(node, node.value(forKey:"__data__"), idx, group)
            }
        }
        return self
    }
}
