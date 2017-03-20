//
//  Call.swift
//  d3s
//
//  Created by ZhangChen on 20/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation

extension Selection {
    func call(name: (Selection, Any, Any, Any, Any, Any) -> (), argument0: Any, argument1: Any, argument2: Any, argument3: Any, argument4: Any) -> Selection {
        name(self, argument0, argument1, argument2, argument3, argument4)
        return self
    }
    
    func call(name: (Selection, Any, Any, Any, Any) -> (), argument0: Any, argument1: Any, argument2: Any, argument3: Any) -> Selection {
        name(self, argument0, argument1, argument2, argument3)
        return self
    }
    
    func call(name: (Selection, Any, Any, Any) -> (), argument0: Any, argument1: Any, argument2: Any) -> Selection {
        name(self, argument0, argument1, argument2)
        return self
    }

    func call(name: (Selection, Any, Any) -> (), argument0: Any, argument1: Any) -> Selection {
        name(self, argument0, argument1)
        return self
    }

    func call(name: (Selection, Any) -> (), argument0: Any) -> Selection {
        name(self, argument0)
        return self
    }

    func call(name: (Selection) -> ()) -> Selection {
        name(self)
        return self
    }

}
