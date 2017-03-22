//
//  Node.swift
//  d3s
//
//  Created by ZhangChen on 19/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation

extension Selection {
    public func node() -> CALayer? {
        for group in _groups {
            for node in group {
                return node
            }
        }
        return nil
    }
}
