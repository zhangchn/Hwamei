//
//  Style.swift
//  d3s
//
//  Created by ZhangChen on 20/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation
import QuartzCore

func recursiveStyle(_ node: CALayer, name: String) -> Any? {
    guard var styleDict = node.style else {
        return type(of:node).defaultValue(forKey: name)
    }
    if let value = styleDict[name] {
        return value
    } else {
        while var styleDict = styleDict["style"] as? [AnyHashable : Any] {
            if let value = styleDict[name] {
                return value
            }
        }
        return type(of:node).defaultValue(forKey: name)
    }
}

extension Selection {
    public typealias StyleFunc = (CALayer, Any?, Int, [CALayer]) -> AnyObject?
    
    public func style(name: String) -> AnyObject? {
        if let node = node() {
            return recursiveStyle(node, name: name) as AnyObject
        } else {
            return nil
        }
    }
    public func style(name: String, value: StyleFunc?) -> Selection {
        return each { (node, data, idx, group) in
            if let v = value?(node, data, idx, group) {
                assert(name != "style")
                var styleDict = node.style ?? [:]
                styleDict[name] = v
                node.style = styleDict
            } else {
                print("\(name): not a style value")
                _ = node.style?.removeValue(forKey: name)
            }
        }
    }
    public func style(name: String, value: AnyObject?) -> Selection {
        return style(name: name, value: { (_, _, _, _) -> AnyObject? in
            return value
        })
    }
}
