//
//  Datum.swift
//  Hwamei
//
//  Created by ZhangChen on 19/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation

extension Selection {
    public func datum() -> Any? {
        return node()?.value(forKey: "__data__")
    }
    public func datum(_ value: Any?) -> Selection {
        return property("__data__", value: value)
    }
}
