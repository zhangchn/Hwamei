//
//  Call.swift
//  d3s
//
//  Created by ZhangChen on 20/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation

extension Selection {
    public func call(_ name: (Selection, Any, Any, Any, Any, Any) -> (), _ argument0: Any, _ argument1: Any, _ argument2: Any, _ argument3: Any, _ argument4: Any) -> Selection {
        name(self, argument0, argument1, argument2, argument3, argument4)
        return self
    }
    
    public func call(_ name: (Selection, Any, Any, Any, Any) -> (), _ argument0: Any, _ argument1: Any, _ argument2: Any, _ argument3: Any) -> Selection {
        name(self, argument0, argument1, argument2, argument3)
        return self
    }
    
    public func call(_ name: (Selection, Any, Any, Any) -> (), _ argument0: Any, _ argument1: Any, _ argument2: Any) -> Selection {
        name(self, argument0, argument1, argument2)
        return self
    }

    public func call(_ name: (Selection, Any, Any) -> (), _ argument0: Any, _ argument1: Any) -> Selection {
        name(self, argument0, argument1)
        return self
    }

    public func call(_ name: (Selection, Any) -> (), _ argument0: Any) -> Selection {
        name(self, argument0)
        return self
    }

    public func call(_ name: (Selection) -> ()) -> Selection {
        name(self)
        return self
    }

}
