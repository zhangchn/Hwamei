//
//  Remove.swift
//  d3s
//
//  Created by ZhangChen on 19/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation

extension Selection {
    public func remove() -> Selection {
        return each() { (node, data, idx, group) in
            node.removeFromSuperlayer()
        }
    }
}
