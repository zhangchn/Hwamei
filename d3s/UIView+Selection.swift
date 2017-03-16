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
    func selectAll(_ p: NSPredicate?) -> Selection {
        return Selection([self.layer.querySelectorAll(p)], parents: [self.layer])
    }
    func selectAll(_ layers: [CALayer]) -> Selection {
        return Selection([layers], parents: [self.layer])
    }
}

extension UIView : SelectionSelect {
    func select(_ p: NSPredicate?) -> Selection {
        return Selection([[self.layer.querySelector(p)].flatMap { $0 }], parents:[self.layer])
    }
    
    func select(_ l: CALayer) -> Selection {
        return Selection([[l]], parents: [self.layer])
    }
}

