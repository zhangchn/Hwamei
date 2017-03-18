//
//  Datum.swift
//  d3s
//
//  Created by ZhangChen on 19/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation

extension Selection {
    func datum() -> Any? {
        return node()?.value(forKey: "__data__")
    }
    func datum(_ value: Any?) -> Selection {
        return property("__data__", value: value)
    }
}
