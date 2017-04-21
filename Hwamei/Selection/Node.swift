//
//  Node.swift
//  Hwamei
//
//  Created by ZhangChen on 19/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation
import QuartzCore

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
