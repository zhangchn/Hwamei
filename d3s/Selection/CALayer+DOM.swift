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
        var stack = IndexPath()
        
        var current: CALayer?
        if let layer = sublayers?.first {
            stack.append(0)
            current = layer
        }
        
        while !stack.isEmpty {
            if p.evaluate(with: current) {
                return current
            } else if !(current?.sublayers?.isEmpty ?? true) {
                stack.append(0)
                current = current?.sublayers!.first
            } else {
                while let last = stack.popLast() {
                    if last < current!.superlayer!.sublayers!.count - 1{
                        stack.append(last + 1)
                        current = current!.superlayer!.sublayers![last + 1]
                        break
                    } else {
                        current = current!.superlayer
                    }
                }
            }
        }
        return nil
    }
    
    public func querySelectorAll(_ p: NSPredicate?) -> [CALayer] {
        guard let p = p else {
            return []
        }
//        if let sublayers = sublayers {
//            return sublayers.filter { p.evaluate(with: $0) }
//        }
//        return []
        var matches :[CALayer] = []
        var stack = IndexPath()
        
        var current: CALayer?
        if let layer = sublayers?.first {
            stack.append(0)
            current = layer
        }
        
        while !stack.isEmpty {
            if p.evaluate(with: current) {
                matches.append(current!)
            }
            if !(current?.sublayers?.isEmpty ?? true) {
                stack.append(0)
                current = current?.sublayers!.first
            } else {
                while let last = stack.popLast() {
                    if last < current!.superlayer!.sublayers!.count - 1{
                        stack.append(last + 1)
                        current = current!.superlayer!.sublayers![last + 1]
                        break
                    } else {
                        current = current!.superlayer
                    }
                }
            }
        }
        return matches
    }
}
