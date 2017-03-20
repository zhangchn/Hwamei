//
//  UIView+Selection.swift
//  d3s
//
//  Created by ZhangChen on 15/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation
import QuartzCore

extension UIView : SelectionSelectAll {
    public func selectAll(_ p: NSPredicate?) -> Selection {
        return Selection([self.layer.querySelectorAll(p)], parents: [self.layer])
    }
    public func selectAll(_ layers: [CALayer]) -> Selection {
        return Selection([layers], parents: [self.layer])
    }
}

extension UIView : SelectionSelect {
    public func select(_ p: NSPredicate?) -> Selection {
        return Selection([[self.layer.querySelector(p)].flatMap { $0 }], parents:[self.layer])
    }
    
    public func select(_ l: CALayer) -> Selection {
        return Selection([[l]], parents: [self.layer])
    }
}

