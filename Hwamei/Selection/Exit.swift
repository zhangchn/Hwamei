//
//  Exit.swift
//  Hwamei
//
//  Created by ZhangChen on 16/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation
import QuartzCore

extension Selection {
    public func exit() -> Selection {
        let exit = _exit ?? [[CALayer]](repeating: [], count: _groups.count)
        return Selection(exit , parents: _parents)
    }
}
