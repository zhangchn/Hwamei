//
//  CALayer+DOM.swift
//  d3s
//
//  Created by ZhangChen on 15/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import QuartzCore

extension CALayer {
    public func querySelector(_ p: NSPredicate?) -> CALayer? {
        guard let p = p else {
            return nil
        }
        if let sublayers = sublayers {
            for l in sublayers {
                if p.evaluate(with: l) {
                    return l
                }
            }
        }
        return nil
    }
    
    public func querySelectorAll(_ p: NSPredicate?) -> [CALayer] {
        guard let p = p else {
            return []
        }
        if let sublayers = sublayers {
            return sublayers.filter { p.evaluate(with: $0) }
        }
        return []
    }
}
