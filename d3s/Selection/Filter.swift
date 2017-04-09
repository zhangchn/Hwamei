//
//  Filter.swift
//  d3s
//
//  Created by ZhangChen on 04/04/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation
import QuartzCore

extension Selection {
    public typealias MatchFunc = (CALayer, Any?, Int, [CALayer]) -> Bool
    public func filter(_ match: @escaping MatchFunc) -> Selection {
        let subgroups = _groups.map { group in
            group.enumerated().filter({ (i,node) -> Bool in
                match(node, node.value(forKey: "__data__"), i, group)
            }).map { $0.1 }
        }
        return Selection(subgroups, parents: _parents)
    }
}
