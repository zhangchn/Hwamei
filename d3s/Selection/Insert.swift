//
//  Insert.swift
//  d3s
//
//  Created by ZhangChen on 01/04/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation

extension Selection {
    
    public func insert(name create: CreatorType, before select: NSPredicate?) -> Selection {
        return insert(name: Selection.creator(name: create), before: select != nil ? selector(select) : nil)
    }
    
    public func insert(name create: CreatorType, before select: SelectorFunc?) -> Selection {
        return insert(name: Selection.creator(name: create), before: select)
    }
    
    public func insert(name create: SelectorFunc, before select: SelectorFunc?) -> Selection {
        let select = select ?? { _, _, _, _ in return nil}
        return self.select({ (layer, datum, index, group) -> CALayer? in
            let beforeSublayer = select(layer, datum, index, group)
            let newLayer = create(layer, datum, index, group)
            newLayer?.contentsScale = UIScreen.main.scale
            if newLayer?.style == nil {
                newLayer?.style = [:]
            }
            layer.insertSublayer(newLayer!, below: beforeSublayer)
            return newLayer
        })

    }
}

extension EnterSelection {
    
    public func insert(name create: CreatorType, before select: NSPredicate?) -> Selection {
        return insert(name: EnterSelection.creator(name: create), before: select != nil ? selector(select) : nil)
    }
    
    public func insert(name create: CreatorType, before select: SelectorFunc?) -> Selection {
        return insert(name: EnterSelection.creator(name: create), before: select)
    }
    
    public func insert(name create: @escaping SelectorFunc, before select: SelectorFunc?) -> Selection {
        let select = select ?? { _, _, _, _ in return nil}
        return self.select({ (layer, datum, index, group) -> CALayer? in
            let beforeSublayer = select(layer, datum, index, group)
            let newLayer = create(layer, datum, index, group)
            newLayer?.contentsScale = UIScreen.main.scale
            if newLayer?.style == nil {
                newLayer?.style = [:]
            }
            layer._parent?.insertSublayer(newLayer!, below: beforeSublayer)
            return newLayer
        })
        
    }
}
