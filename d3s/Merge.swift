//
//  Merge.swift
//  d3s
//
//  Created by ZhangChen on 20/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation

extension Selection {
    func merge(_ selection: Selection) -> Selection {
        let minCount = min(_groups.count , selection._groups.count)
        var merges: [[CALayer]] = zip(_groups, selection._groups).map { (group0, group1) -> [CALayer] in
            return  group0 + Array(Set(group1).subtracting(group0))
        }
        for j in minCount..<_groups.count {
            merges.append(_groups[j])
        }
        return Selection(merges, parents: _parents)
    }
}
